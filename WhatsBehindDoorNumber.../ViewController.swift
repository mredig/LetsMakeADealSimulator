//
//  ViewController.swift
//  WhatsBehindDoorNumber...
//
//  Created by Michael Redig on 6/20/19.
//  Copyright © 2019 Red_Egg Productions. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

	@IBAction func doButtonAction(_ sender: NSButton) {
		runSim()
	}

	func runSim() {



	}

	func generateDoors(switchingUponReveal: Bool) {
		
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
