const main = async() =>{
    const[owner, randomPerson] = await hre.ethers.getSigners();
    const waveContractFactory=await hre.ethers.getContractFactory("WavePortal");
    const waveContract= await waveContractFactory.deploy({
        value:hre.ethers.utils.parseEther("0.1")
    });
    await waveContract.deployed();
    console.log("contract deployed at: ",waveContract.address);

    let contractBalance = await hre.ethers.provider.getBalance(
        waveContract.address
    );
    console.log("Contracts Balance: ",
     hre.ethers.utils.formatEther(contractBalance)
    );
    
    let waveTxn = await waveContract.wave("hello !!!");
    await waveTxn.wait();

    waveTxn = await waveContract.connect(randomPerson).wave("howdy there!!!");
    await waveTxn.wait();
    
    waveTxn = await waveContract.wave("hello !!!");
    await waveTxn.wait();

    contractBalance= await hre.ethers.provider.getBalance(
        waveContract.address
    );
    console.log("New Balance: ",hre.ethers.utils.formatEther(contractBalance));

    let allWaves= await waveContract.getAllWaves();
    console.log(allWaves);// this right here
};

const runMain = async () => {
    try{
        await main();
        process.exit(0);
    } catch(error){
        console.log(error);
        process.exit(1);
    }
};

runMain();