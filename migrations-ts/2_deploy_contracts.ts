//async function (deployer, network, accounts) {}
module.exports = async function() {
    console.debug('Deploy here.');
} as Truffle.Migration;

// because of https://stackoverflow.com/questions/40900791/cannot-redeclare-block-scoped-variable-in-unrelated-files
export {};
