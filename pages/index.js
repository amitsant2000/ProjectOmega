import Head from 'next/head'
import React, { Component } from 'react'
import { ELECTION_ABI, ELECTION_ADDRESS } from '../config'
import Web3 from 'web3'

var wrap = (x) => {
  return Web3.utils.fromAscii(x)
}
var unwrap = (x) => {
  return Web3.utils.toAscii(x)
}

class App extends Component {
  componentWillMount() {
    this.loadBlockchainData()
  }

  async loadBlockchainData() {
    var web3 = new Web3(Web3.givenProvider || "http://localhost:8545")
    var accounts = await web3.eth.getAccounts()
    var tally = new Map()
    var c = await new web3.eth.Contract(ELECTION_ABI)
    await c.methods.addCandidate(wrap("Joe Mama"))
    var y = await c.methods.getCandidateNextID();
    console.log(y)
    var numCandidates = unwrap(await c.methods.getCandidateNextID())
    console.log(numCandidates)
    var tally = new Map()
    for (x in Array(numCandidates).keys()) {
      tally[await web3.eth.getCandidateByID(x)] = await web3.eth.checkTally(web3.fromAscii(candidate))
    }
    console.log(tally)
    this.setState({ account: accounts[0], tally: tally })
  }

  constructor(props) {
    super(props)
    this.state = { account: '', tally: new Map() }
  }

  render() {
    return (
      <div className="container">
        <h1>Hello, World!</h1>
        <p>Your account: {this.state.account}</p>
      </div>
    );
  }
}

export default App;
