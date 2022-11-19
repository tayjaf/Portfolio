import { useState, useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { Button, Spinner, Container, Row, Col } from 'react-bootstrap';
import Web3 from 'web3';
import axios from 'axios';
import FormData from 'form-data';
import detectEthereumProvider from '@metamask/detect-provider';
import TransactionReceipt from './modals/TransactionReceipt';
import Ricer from './build/Ricer.json';
import leftArrow from './images/left.png';
import rightArrow from './images/right.png';

import {
  incrementModel,
  decrementModel,
  incrementColor,
  decrementColor,
  incrementSpoiler,
  decrementSpoiler,
  incrementRims,
  decrementRims,
  incrementStickers,
  decrementStickers
} from './redux/actions/controlActions';

const TableControls = () => {
  const [ricer, setRicer] = useState();
  const [provider, setProvider] = useState();
  const [currentMetaMaskAccount, setCurrentMetaMaskAccount] = useState(null);
  let [isConnected, setIsConnected] = useState();
  let [isMinting, setIsMinting] = useState();
  let [modalShow, setModalShow] = useState(false);
  let [modalShowData, setModalShowData] = useState({});

  useEffect(() => {
    const init = async () => {
      const provider = await detectEthereumProvider();
      if (provider) {
        setProvider(provider);
        startApp(provider);
      } else {
        alert('Please install MetaMask!');
        setIsConnected(false);
        setIsMinting(false);
        return;
      };

      async function startApp(provider) {
        if (provider !== window.ethereum) {
          alert('Do you have multiple wallets installed?');
          setIsConnected(false);
          setIsMinting(false);
          return;
        };

        let web3 = new Web3(provider);

        //create ricer instance to interact with deployed Ricer contract
        const networkId = await web3.eth.net.getId();
        const deploymentNetwork = Ricer.networks[networkId];
        if (deploymentNetwork !== undefined) {
          const deployedRicer = new web3.eth.Contract(
            Ricer.abi,
            deploymentNetwork.address
          );
          setRicer(deployedRicer);
        };

        let accounts = await provider.request({ method: 'eth_accounts' });
        if (accounts.length > 0) {
          setIsConnected(true);
          setCurrentMetaMaskAccount(accounts[0]);
        };
      };
    };
    init();

    return () => setIsConnected(false);
  }, []);

  const getAccounts = async () => {
    const accounts = await provider.request({ method: 'eth_requestAccounts' });
    await handleAccountsChanged(accounts);
  };

  function handleAccountsChanged(accounts) {
    if (accounts.length === 0) {
      console.log('Please connect to MetaMask.');
    } else if (accounts[0] !== currentMetaMaskAccount) {
      setCurrentMetaMaskAccount(accounts[0]);
      setIsConnected(true);
      // window.location.reload();
    }
  };

  const connectToMetaMask = async () => {
    await getAccounts();
    provider.on('accountsChanged', handleAccountsChanged);
  };

  const handleOnMint = async () => {
    try {
      //Ensure that the user is signed in with MetaMask
      let accounts = await provider.request({ method: 'eth_accounts' });
      if (accounts.length === 0) {
        alert('Please connect using MetaMask');
        setCurrentMetaMaskAccount(null);
        setIsConnected(false);
        return;
      };

      setIsMinting(true);
      //Generate the path to the .png file selected by the user
      //Development:
      // let cidPath = require(`../public/images/${storedPng.storedPngAsString}.png`).default;
      //Production:
      let cidPath = `${process.env.PUBLIC_URL}/images/${storedPng.storedPngAsString}.png`;

      //Generate the cid for the user's .png file on IPFS
      let cid = await createPngCid(cidPath);
      //Generate a cid for the metadata of the NFT and set it on IPFS
      let metadataCid = await createMetadataCid(cid);
      //Mint the NFT on the blockchain by using the metadata cid and the address of the user currently signed into MetaMask
      let mintedRicer = await ricer.methods.mintToken(accounts[0], metadataCid).send({from: currentMetaMaskAccount});
      //Get token id and transaction hash from the transaction receipt
      let tokenId = mintedRicer.events.Transfer.returnValues.tokenId;
      let transactionHash = mintedRicer.transactionHash;
      //Create links to display NFT data
      let cidLink = `https://ipfs.io/ipfs/${cid}`;
      let metadataCidLink = `https://ipfs.io/ipfs/${metadataCid}`;
      let transactionHashLink = `https://rinkeby.etherscan.io/tx/${transactionHash}`;
      //Set state variables
      setModalShowData({
        tokenId,
        cidLink,
        metadataCidLink,
        transactionHashLink
      });

      setModalShow(true);
      setIsMinting(false);
    } catch (error) {
        setIsMinting(false);
        alert('Please check your MetaMask account and refresh your browser');
    };
  };

//Uses .png file path as input and returns a cid on IPFS of the .png file
  const createPngCid = async pngPath => {
    //Retrieve user's selected .png file from /build
    let pngFile = await axios.get(pngPath, {responseType: 'blob'});
    //Convert the .png file to a blob and send it to the backend
    const data = new FormData();
    data.append('blob', pngFile.data);

    // Development
    // let res = await axios.post(
    //   'http://localhost:5000/createimagecid',
    //   data);

    //Production
    let res = await axios.post(
      'https://desolate-dusk-16956.herokuapp.com/createimagecid',
      data);

    //Return the content identifier for the .png file on IPFS
    return res.data;
  };

//Creates a cid for the metadata of the users .png cid
  const createMetadataCid = async pngCid => {
    let metadata = {
      image: pngCid,
      model,
      color,
      spoiler,
      rims,
      stickers
    };
    //Send the metadata object to generate a cid on IPFS
    //Development
    // let metadataCid = await axios.post(
    //   'http://localhost:5000/createmetadatacid',
    //   JSON.stringify(metadata)
    // );

    //Production
    let metadataCid = await axios.post(
      'https://desolate-dusk-16956.herokuapp.com/createmetadatacid',
      JSON.stringify(metadata)
    );

    return metadataCid.data;
  };

  let [model, setModel] = useState(0);
  let [color, setColor] = useState(0);
  let [spoiler, setSpoiler] = useState(0);
  let [stickers, setStickers] = useState(0);
  let [rims, setRims] = useState(0);

  const dispatch = useDispatch();
  let storedPng = useSelector(state => {
    let pngObject = state.storedPng;
    let storedPngAsString = Object.values(pngObject).map(num => num.toString()).join('');
    return {storedPngAsString};
  });

  const handleModelIncrement = () => {
    let newModel = ++model;
    if (newModel === 4) {
      setModel(0);
      dispatch(incrementModel(0));
      return;
    };
    if (newModel > 3) {
      setModel(0);
      return;
    };
    setModel(newModel);
    dispatch(incrementModel(newModel));
  };

  const handleModelDecrement = () => {
    let newModel = --model;
    if (newModel === -1) {
      setModel(3);
      dispatch(decrementModel(3));
      return;
    }
    if (newModel < 0) {
      setModel(3);
      return;
    };
    setModel(newModel);
    dispatch(decrementModel(newModel));
  };

  const handleColorIncrement = () => {
    let newColor = ++color;
    if (newColor === 4) {
      setColor(0);
      dispatch(incrementColor(0));
      return;
    };
    if (newColor > 3) {
      setColor(0);
      return;
    };
    setColor(newColor);
    dispatch(incrementColor(newColor));
  };

  const handleColorDecrement = () => {
    let newColor = --color;
    if (newColor === -1) {
      setColor(3);
      dispatch(decrementColor(3));
      return;
    }
    if (newColor < 0) {
      setColor(3);
      return;
    };
    setColor(newColor);
    dispatch(decrementColor(newColor));
  };

  const handleSpoilerIncrement = () => {
    let newSpoiler = ++spoiler;
    if (newSpoiler === 4) {
      setSpoiler(0);
      dispatch(incrementSpoiler(0));
      return;
    };
    if (newSpoiler > 3) {
      setSpoiler(0);
      return;
    };
    setSpoiler(newSpoiler);
    dispatch(incrementSpoiler(newSpoiler));
  };

  const handleSpoilerDecrement = () => {
    let newSpoiler = --spoiler;
    if (newSpoiler === -1) {
      setSpoiler(3);
      dispatch(decrementSpoiler(3));
      return;
    }
    if (newSpoiler < 0) {
      setSpoiler(3);
      return;
    };
    setSpoiler(newSpoiler);
    dispatch(decrementSpoiler(newSpoiler));
  };

  const handleStickersIncrement = () => {
    let newStickers = ++stickers;
    if (newStickers === 4) {
      setStickers(0);
      dispatch(incrementStickers(0));
      return;
    };
    if (newStickers > 3) {
      setStickers(0);
      return;
    };
    setStickers(newStickers);
    dispatch(incrementStickers(newStickers));
  };

  const handleStickersDecrement = () => {
    let newStickers = --stickers;
    if (newStickers === -1) {
      setStickers(3);
      dispatch(decrementStickers(3));
      return;
    }
    if (newStickers < 0) {
      setStickers(3);
      return;
    };
    setStickers(newStickers);
    dispatch(decrementStickers(newStickers));
  };

  const handleRimsIncrement = () => {
    let newRims = ++rims;
    if (newRims === 5) {
      setRims(0);
      dispatch(incrementRims(0));
      return;
    };
    if (newRims > 4) {
      setRims(0);
      return;
    };
    setRims(newRims);
    dispatch(incrementRims(newRims));
  };

  const handleRimsDecrement = () => {
    let newRims = --rims;
    if (newRims === -1) {
      setRims(4);
      dispatch(decrementRims(4));
      return;
    }
    if (newRims < 0) {
      setRims(4);
      return;
    };
    setRims(newRims);
    dispatch(decrementRims(newRims));
  };


  const MODELS = ["NEON", "CIVIC", "INTEGRA", "MIATA"];
  const COLORS = ["BLACK", "BLUE", "GREEN", "RED"];
  const SPOILERS = ["DAYTONA", "DRAG", "CARBON", "HOONICORN"];
  const STICKERS = ["RICERS", "FLAMES", "CHECKERED", "ALL OVER"];
  const RIMS = ["BREDRIN", "GOTHIC", "CODE RED", "RIFKIND", "FAT JOE"];

  return (
      <Container>
        <Row>
          <Col lg="3" sm="3" xs="3" className="mt-4 selector-col">
            <div className="selector-label">
              Model
            </div>
            <div className="d-flex justify-content-around selector">
              <img className="leftArrow" src={leftArrow} onClick={handleModelDecrement} alt="model decrement"></img>
              <div className="p-2">{MODELS[model]}</div>
              <img className="rightArrow" src={rightArrow} onClick={handleModelIncrement} alt="model increment"></img>
            </div>

            <div className="selector-label">
              Color
            </div>
            <div className="d-flex justify-content-around selector">
              <img className="leftArrow" src={leftArrow} onClick={handleColorDecrement} alt="color decrement"></img>
              <div className="p-2">{COLORS[color]}</div>
              <img className="rightArrow" src={rightArrow} onClick={handleColorIncrement} alt="color increment"></img>
            </div>

            <div className="selector-label">
              Spoiler
            </div>
            <div className="d-flex justify-content-around selector">
              <img className="leftArrow" src={leftArrow} onClick={handleSpoilerDecrement} alt="spoiler decrement"></img>
              <div className="p-2">{SPOILERS[spoiler]}</div>
              <img className="rightArrow" src={rightArrow} onClick={handleSpoilerIncrement} alt="spoiler increment"></img>
            </div>

            <div className="selector-label">
              Decals
            </div>
            <div className="d-flex justify-content-around selector">
              <img className="leftArrow" src={leftArrow} onClick={handleStickersDecrement} alt="sticker decrement"></img>
              <div className="p-2">{STICKERS[stickers]}</div>
              <img className="rightArrow" src={rightArrow} onClick={handleStickersIncrement} alt="sticker increment"></img>
            </div>

            <div className="selector-label">
              Rims
            </div>
            <div className="d-flex justify-content-around selector">
              <img className="leftArrow" src={leftArrow} onClick={handleRimsDecrement} alt="rims decrement"></img>
              <div className="p-2">{RIMS[rims]}</div>
              <img className="rightArrow" src={rightArrow} onClick={handleRimsIncrement} alt="rims increment"></img>
            </div>

            <div className="d-flex justify-content-around button-div">
              {(isMinting && isConnected)
                ? <Button variant="secondary" disabled>
                    <Spinner
                      as="span"
                      animation="border"
                      size="sm"
                      role="status"
                      aria-hidden="true"
                    />
                    Minting...
                  </Button>
                : (!isMinting && isConnected)
                  ? <Button onClick={handleOnMint} variant="secondary">
                       Mint your Ricer NFT!
                    </Button>
                  : <Button onClick={connectToMetaMask} variant="secondary">
                      Connect to your MetaMask account
                    </Button>
              }
            </div>

            <TransactionReceipt
              tokenid={modalShowData.tokenId}
              cidlink={modalShowData.cidLink}
              metadatacidlink={modalShowData.metadataCidLink}
              transactionhashlink={modalShowData.transactionHashLink}
              show={modalShow}
              onHide={() => setModalShow(false)}
            />
          </Col>

          {/*Development
          <Col lg="9" sm="9" xs="9">
              <img
                className="body carImage"
                src={require(`../public/images/${storedPng.storedPngAsString}.png`).default}
                alt="car"></img>
          </Col>
          */}

          {/*Production*/}
          <Col lg="9" sm="9" xs="9">
              <img
                className="body carImage"
                src={`${process.env.PUBLIC_URL}/images/${storedPng.storedPngAsString}.png`}
                alt="car"></img>
          </Col>        
        </Row>
      </Container>
  );
};

export default TableControls;
