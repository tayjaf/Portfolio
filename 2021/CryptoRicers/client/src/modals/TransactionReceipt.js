import { Modal, Button } from 'react-bootstrap';

const TransactionReceipt = (props) => {
  return (
    <Modal
      {...props}
      size="md"
      aria-labelledby="contained-modal-title-vcenter"
      centered
    >
      <Modal.Body className="modal-receipt-color modal-receipt-data">
        <div>
          Your Ricer token id is: <b>{props.tokenid}</b>
        </div>
        <div>
          <a className="modal-receipt-links"
            href= {props.cidlink}
            target="_blank"
            rel="noopener noreferrer"
          >
            Click here to view your Ricer on IPFS!
          </a>
        </div>
        <div >
          <a className="modal-receipt-links"
            href= {props.metadatacidlink}
            target="_blank"
            rel="noopener noreferrer"
          >
            Click for your Ricer's metadata
          </a>
        </div>
        <div >
          <a className="modal-receipt-links"
            href= {props.transactionhashlink}
            target="_blank"
            rel="noopener noreferrer"
          >
            Click to see the transaction information on Etherscan
          </a>
        </div>
      </Modal.Body>

        <div className="modal-receipt-image-div">
          <img
            className="modal-receipt-image"
            src={props.cidlink}
            alt="ricer"
          />
        </div>

      <div className="modal-receipt-color modal-receipt-footer">
        <Button className="modal-receipt-button" onClick={props.onHide} variant='info'>Close</Button>
      </div>

    </Modal>
  );
};

export default TransactionReceipt;
