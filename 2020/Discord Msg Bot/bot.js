var Discord = require('discord.io');
var logger = require('winston');
var auth = require('./auth.json');
// Configure logger settings
logger.remove(logger.transports.Console);
logger.add(new logger.transports.Console, {
    colorize: true
});
logger.level = 'debug';
// Initialize Discord Bot
var bot = new Discord.Client({
   token: auth.token,
   autorun: true
});
bot.on('ready', function (evt) {
    logger.info('Connected');
    logger.info('Logged in as: ');
    logger.info(bot.username + ' - (' + bot.id + ')');
});
bot.on('message', function (user, userID, channelID, message, evt) {
    // Our bot needs to know if it will execute a command
    // It will listen for messages that will start with `!`
    if (message.substring(0, 1) == '$') {
        var args = message.substring(1).split(' ');
        var cmd = args[0];
       
        args = args.splice(1);
        switch(cmd) {
			case 'smell':
                bot.sendMessage({
                    to: channelID,
                    message: 'https://tenor.com/view/when-the-money-flows-vince-mc-mahon-gif-17939701'
                });
            break;
			case 'cg':
				bot.sendMessage({
					to: channelID,
					message: 'https://www.coingecko.com/en/coins/softlink'
				});
			break;
			case 'etherscan':
				bot.sendMessage({
					to:	channelID,
					message: 'https://etherscan.io/token/0x10bae51262490b4f4af41e12ed52a0e744c1137a'
				});
			break;
			case 'dex':
				bot.sendMessage({
					to:	channelID,
					message: 'https://www.dextools.io/app/uniswap/pair-explorer/0xe2f021411a15f677100a79f1bf6afd89d00c778b'
				});
			break;
			case 'needful':
				bot.sendMessage({
					to: channelID,
					message: '$wb'
				});
			break;
			case 'help':
				bot.sendMessage({
					to: channelID,
					message: '$smell, $cg, $etherscan, $dex'
				});
			break;
            // Just add any case commands if you want to..
         }
     }
});