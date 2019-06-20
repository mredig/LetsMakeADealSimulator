//
//  ViewController.swift
//  WhatsBehindDoorNumber...
//
//  Created by Michael Redig on 6/20/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

	var printAlong = false

	@IBAction func doButtonAction(_ sender: NSButton) {
		runSim()
	}

	func runSim() {

		let total = 1000

		var stubbornWins = 0
		for _ in 1...total {
			stubbornWins += playGame(switchingUponReveal: false) ? 1 : 0
		}

		var switchingWins = 0
		for _ in 1...total {
			switchingWins += playGame(switchingUponReveal: true) ? 1 : 0
		}

		var randomSelectionWins = 0
		for _ in 1...total {
			randomSelectionWins += playGame(switchingUponReveal: Bool.random()) ? 1 : 0
		}

		print("stubborn win rate: \(Double(stubbornWins) / Double(total))")
		print("switching win rate: \(Double(switchingWins) / Double(total))")
		print("random choice win rate: \(Double(randomSelectionWins) / Double(total))")

	}

	func playGame(switchingUponReveal: Bool) -> Bool {
		let selection = Int.random(in: 0..<3)

		var game = Game()
		game.choose(doorNumber: selection)
		console("Chose \(selection): ", false)

		console("Revealed \(game.revealABadDoor()): ", false)
		if switchingUponReveal {
			game.switchToUnknownDoor()
			console("Switching Choice to \(game.myChoice): ", false)
		}

		console("Winning Door was: \(game.winningDoor)", true)
		return game.didWin
	}

	func console(_ string: String, _ newLine: Bool) {
		if printAlong{
			print(string, terminator: newLine ? "\n" : "")
		}
	}
}

enum Door {
	case win
	case lose
}

struct Game {
	var doors: [Door] = [.win, .lose, .lose]

	var myChoice: Int = -1
	var revealed: Int = -1

	var didWin: Bool {
		guard (0..<3).contains(myChoice) else { return false }
		return doors[myChoice] == .win
	}
	var winningDoor: Int {
		guard let winning = doors.firstIndex(of: .win) else { fatalError() }
		return winning
	}

	init() {
		doors.shuffle()
	}

	mutating func choose(doorNumber: Int) {
		myChoice = doorNumber
	}

	mutating func revealABadDoor() -> Int {
		guard revealed == -1 else { return revealed }
		var random = Int.random(in: 0..<3)
		while random == myChoice || doors[random] == .win {
			random = Int.random(in: 0..<3)
		}
		revealed = random
		return revealed
	}

	mutating func switchToUnknownDoor() {
		var doorsTouched = [false, false, false]
		doorsTouched[myChoice] = true
		doorsTouched[revealed] = true
		guard let otherDoor = doorsTouched.firstIndex(of: false) else { return }
		myChoice = otherDoor
	}
}
