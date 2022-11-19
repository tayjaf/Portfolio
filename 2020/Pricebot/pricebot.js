var Discord = require('discord.js');
var logger = require('winston');
const client = new Discord.Client();

client.once('ready', () => {
	console.log('Ready!');
});

const priceChannel = client.channels.cache.get("INSERTDISCORD")
client.login('INSERT');

// Configure logger settings
logger.remove(logger.transports.Console);
logger.add(new logger.transports.Console, {
	colorize: true
});
logger.level = 'debug';

client.on('ready', function (evt) {
	logger.info('Connected');
	logger.info('Logged in as: ');
	logger.info(client.username + ' - (' + client.id + ')');
});

const Web3 = require('web3');
const web3 = new Web3('wss://mainnet.infura.io/ws/v3/INSERT');
var hexToDec = require('hex-to-dec');
var move_decimal = require('move-decimal-point');
var scientificToDecimal = require('scientific-to-decimal');
const ethers = require('ethers');
let privateKey = "INSERT";
const { createConnection } = require('net');
let provider = new ethers.providers.InfuraProvider("homestead", {
	projectId: "INSERT",
	projectSecret: "INSERT"
});
let wallet = new ethers.Wallet(privateKey, provider);


let tokenAddress = '0x8A9C67fee641579dEbA04928c4BC45F66e26343A';
let sushirouterAddress = '0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F';
let routerAddress = "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D";
let WETHAddress = '0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2';
let USDCAddress = '0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48';

let routerAbi = [
	"function getAmountsOut(uint amountIn, address[] path) external view returns (uint[] amounts)"
];

let routerContract = new ethers.Contract(routerAddress, routerAbi, wallet);
let sushirouterContract = new ethers.Contract(sushirouterAddress, routerAbi, wallet);


let tokenAmountIn =  move_decimal(1,18);
let tokenToEthPath = [tokenAddress, WETHAddress];
let WETHToUSDCPath = [WETHAddress,USDCAddress];

var tempPrice = [];
var sushiTempPrice = [];
var tempEthPrice = [];
var sushiTempEthPrice = [];

async function sushitokenToEth(){ //IMPORTANT ADDITION
	let sushipriceArray = await sushirouterContract.getAmountsOut(tokenAmountIn, tokenToEthPath);
	let sushibigEthPrice = ethers.BigNumber.from(sushipriceArray[1]);
	//console.log(bigEthPrice);
	let sushiethPrice = ethers.utils.formatEther(sushibigEthPrice);
	await sushitokenToUSDC(sushibigEthPrice);
}

async function sushitokenToUSDC(sushiethAmount){ //IMPORTANT ADDITION
	let sushiethPrice = sushiethAmount;
	let sushipriceArray = await sushirouterContract.getAmountsOut(sushiethPrice, WETHToUSDCPath);
	let sushibigUSDCPrice = ethers.BigNumber.from(sushipriceArray[1]);
	let sushiUSDCPrice = ethers.utils.formatEther(sushibigUSDCPrice);
	sushiTempPrice.length = 0;
	sushiTempPrice.push(move_decimal(sushiUSDCPrice,12));
	sushiTempEthPrice.length = 0;
	sushiTempEthPrice.push(move_decimal(sushiethPrice,-18));
//	client.channels.cache.get("793241673572417536").send(`1 $SUSHI equals ${move_decimal(USDCPrice,12)} USDC`);
	//client.channels.cache.get("793241673572417536").send("---------------------------------")
	
}

async function tokenToEth(){
	let priceArray = await routerContract.getAmountsOut(tokenAmountIn, tokenToEthPath);
	let bigEthPrice = ethers.BigNumber.from(priceArray[1]);
	//console.log(bigEthPrice);
	let ethPrice = ethers.utils.formatEther(bigEthPrice);
	await tokenToUSDC(bigEthPrice);
}

async function tokenToUSDC(ethAmount){
	let ethPrice = ethAmount;
	let priceArray = await routerContract.getAmountsOut(ethPrice, WETHToUSDCPath);
	let bigUSDCPrice = ethers.BigNumber.from(priceArray[1]);
	let USDCPrice = ethers.utils.formatEther(bigUSDCPrice);
	tempPrice.length = 0;
	tempPrice.push(move_decimal(USDCPrice,12));
	tempEthPrice.length = 0;
	tempEthPrice.push(move_decimal(ethPrice,-18));
//	client.channels.cache.get("793241673572417536").send(`1 $SUSHI equals ${move_decimal(USDCPrice,12)} USDC`);
	//client.channels.cache.get("793241673572417536").send("---------------------------------")
	
}


client.once("ready", () => { 
	web3.eth.subscribe('logs', {
		address: '0x2b6A25f7C54F43C71C743e627F5663232586C39F',	//pair address
		topics: ['0xd78ad95fa46c994b6551d0da85fc275fe613ce37657fb8d5e3d130840159d822']
	}, (error, result) => {
		if (error)
			console.error(error);
	})
		.on("connected", function (swaps) {
			console.log(swaps);
		})
		.on("data", function (log) {
			var dataToSplit = log["data"];
			const txHash = log["transactionHash"];
			dataToSplit = dataToSplit.toString().substring(2);
			web3.eth.getTransactionReceipt(log["transactionHash"]).then(res => {
			const {logs, from} = res;
			const logsFiltered = logs.filter(i => i.address === "0x2b6A25f7C54F43C71C743e627F5663232586C39F")
			//console.log(logsFiltered);
			})
		var dataSplitted = dataToSplit.toString().split(/(.{64})/).filter(O=>O);
		hexToDec();
		let amount0in = move_decimal(hexToDec(dataSplitted[0]), -18);    //ETH
		let amount1in = move_decimal(hexToDec(dataSplitted[1]), -18);    //TOKEN OF CHOICE
		let amount0out = move_decimal(hexToDec(dataSplitted[2]), -18);  //ETH
		let amount1out = move_decimal(hexToDec(dataSplitted[3]), -18);   //TOKEN OF CHOICE
		amount0in = scientificToDecimal(amount0in);
		amount0in = parseFloat(amount0in).toFixed(0);
		amount0out = scientificToDecimal(amount0out);
		amount0out = parseFloat(amount0out).toFixed(0);
		amount1in = scientificToDecimal(amount1in);
		amount1in = parseFloat(amount1in).toFixed(2);
		amount1out = scientificToDecimal(amount1out);
		amount1out = parseFloat(amount1out).toFixed(2);
	//	client.channels.cache.get("793241673572417536").send("---------------------------------");
			console.log(txHash);
			if (amount1in == 0){
				tokenToEth()
				client.channels.cache.get("793241673572417536").send({embed: {
					color: 15158332,
					thumbnail: {
						url: 'https://i.ibb.co/Z607Cm8/red.png',},
					title: "Jarvis Tracker - Uniswap v2  <:761363433412231178:800155287616880680>  ",
					fields: [{
						name:  `**SOLD:\t${amount0in} <:796158458931707974:800151094352805929>**`,
						value: `** **`
					},
					{
						name: `FOR:\t${amount1out} <:724133930659348500:800151094596599838>\n`,
						value: `** **`
					},
					{
						name: "JRT PRICE:",
						value: "```json\nUSD: " + tempPrice + "\n ETH: " + parseFloat(tempEthPrice).toFixed(6).toString() + "\n```" + `\n[\[Etherscan\]](https://etherscan.io/tx/` + txHash + `)\n`
					}],
					timestamp: new Date(),
					footer: {
					  icon_url: client.user.avatarURL,
					  text: "made with ❤️ for JRT"
					}
				  }
				});
					
				//client.channels.cache.get("793241673572417536").send(`${amount0in} $SUSHI was sold for ${amount1out} ETH`); 
				}else{
					tokenToEth()
					client.channels.cache.get("793241673572417536").send({embed: {
						color: 3066993,
						thumbnail: {
							url: 'https://i.ibb.co/xSDNT9q/green.png'},
							title: "Jarvis Tracker - Uniswap v2  <:761363433412231178:800155287616880680>",
							fields: [{
								name:  `**BOUGHT:\t${amount0out} <:796158458931707974:800151094352805929>**`,
								value: `** **`
							},
							{
								name: `WITH:\t${amount1in} <:724133930659348500:800151094596599838>\n`,
								value: `** **`
							},
							{
								name: "JRT PRICE:",
								value: "```json\nUSD: " + tempPrice + "\n ETH: " + parseFloat(tempEthPrice).toFixed(6).toString() + "\n```" + `\n[\[Etherscan\]](https://etherscan.io/tx/` + txHash + `)\n`
							}],
						timestamp: new Date(),
						footer: {
						  icon_url: client.user.avatarURL,
						  text: "made with ❤️ for JRT"
						}
					  }
					});
					//client.channels.cache.get("793241673572417536").send(`${amount0out} $SUSHI was bought with ${amount1in} ETH`); 
				}
			});
			tokenToEth()
	
			web3.eth.subscribe('logs', {
				address: '0xF1360C4ae1cead17B588ec1111983d2791B760d3',
				topics: ['0xd78ad95fa46c994b6551d0da85fc275fe613ce37657fb8d5e3d130840159d822']
			}, (error, result) => {
				if (error)
					console.error(error);
			})
				.on("connected", function (swaps) {
					console.log(swaps);
				})
				.on("data", function (log) {
					var dataToSplit = log["data"];
					const txHash = log["transactionHash"];
					dataToSplit = dataToSplit.toString().substring(2);
					web3.eth.getTransactionReceipt(log["transactionHash"]).then(res => {
					const {logs, from} = res;
					const logsFiltered = logs.filter(i => i.address === "0xF1360C4ae1cead17B588ec1111983d2791B760d3")
					//console.log(logsFiltered);
					})
				var dataSplitted = dataToSplit.toString().split(/(.{64})/).filter(O=>O);
				hexToDec();
				let amount0in = move_decimal(hexToDec(dataSplitted[0]), -18);    //ETH
				let amount1in = move_decimal(hexToDec(dataSplitted[1]), -18);    //TOKEN OF CHOICE
				let amount0out = move_decimal(hexToDec(dataSplitted[2]), -18);  //ETH
				let amount1out = move_decimal(hexToDec(dataSplitted[3]), -18);   //TOKEN OF CHOICE
				amount0in = scientificToDecimal(amount0in);
				amount0in = parseFloat(amount0in).toFixed(0);
				amount0out = scientificToDecimal(amount0out);
				amount0out = parseFloat(amount0out).toFixed(0);
				amount1in = scientificToDecimal(amount1in);
				amount1in = parseFloat(amount1in).toFixed(2);
				amount1out = scientificToDecimal(amount1out);
				amount1out = parseFloat(amount1out).toFixed(2);
				//client.channels.cache.get("793241673572417536").send("---------------------------------");
					if (amount1in == 0){
						sushitokenToEth() //IMPORTANT ADDITION
						client.channels.cache.get("793241673572417536").send({embed: {
							color: 15158332,
							title: "Jarvis Tracker - Sushiswap <:a3fdf36792c57acefbd11c5cf628a617:800155287738122270>",
							thumbnail: {
								url: 'https://i.ibb.co/Z607Cm8/red.png'},
							fields: [{
								name: `**SOLD:\t${amount0in} <:796158458931707974:800151094352805929>**`,
								value: `** **`
							},
							{
								name: `FOR:\t${amount1out} <:724133930659348500:800151094596599838>\n` + `\n`,
								value: `** **`
							},
							{
								name: "JRT PRICE:",
								value: "```json\nUSD: " + sushiTempPrice + "\nETH: " + parseFloat(sushiTempEthPrice).toFixed(6).toString() + "\n```" + `\n[\[Etherscan\]](https://etherscan.io/tx/` + txHash + `)\n`
							}],
							timestamp: new Date(),
							footer: {
							  icon_url: client.user.avatarURL,
							  text: "made with ❤️ for JRT"
							}
						  }
						});
						//client.channels.cache.get("793241673572417536").send(`${scientificToDecimal(amount0in)} $SUSHI was sold for ${scientificToDecimal(amount1out)} ETH`); 
						}else{
							sushitokenToEth() //IMPORTANT ADDITION
							client.channels.cache.get("793241673572417536").send({embed: {
								color: 3066993,
								title: "Jarvis Tracker - Sushiswap <:a3fdf36792c57acefbd11c5cf628a617:800155287738122270>",
								thumbnail: {
									url: 'https://i.ibb.co/Z607Cm8/red.png'},
								fields: [{
									name: `**BOUGHT:\t${amount0out} <:796158458931707974:800151094352805929>**`,
									value: `** **`
								},
								{
									name: `WITH:\t${amount1in} <:724133930659348500:800151094596599838>\n` + `\n`,
									value: `** **`
								},
								{
									name: "JRT PRICE:",
									value: "```json\nUSD: " + sushiTempPrice + "\nETH: " + parseFloat(sushiTempEthPrice).toFixed(6).toString() + "\n```" + `\n[\[Etherscan\]](https://etherscan.io/tx/` + txHash + `)\n`
								}],
								timestamp: new Date(),
								footer: {
								  icon_url: client.user.avatarURL,
								  text: "made with ❤️ for JRT"
								}
							  }
							});
							//client.channels.cache.get("793241673572417536").send(`${scientificToDecimal(amount0out)} $SUSHI was bought with ${scientificToDecimal(amount1in)} ETH`); 
						}
					tokenToEth()
			
				});
		});