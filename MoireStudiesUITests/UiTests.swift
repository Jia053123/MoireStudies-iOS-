//
//  UiTests.swift
//  MoireStudiesUITests
//
//  Created by Jialiang Xiang on 2021-01-23.
//

import XCTest

class UiTests: XCTestCase {
    var app: XCUIApplication!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        XCUIDevice.shared.orientation = .landscapeLeft
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func mainViewCheckSch1() {
        XCTAssert(app.otherElements["MainView"].exists)
        XCTAssert(app.otherElements["SliderCtrlViewSch1"].exists)
        XCTAssert(app.otherElements.matching(identifier: "SliderCtrlViewSch1").count == 2)
        XCTAssert(app.otherElements["CoreAnimPatternView"].exists)
        XCTAssert(app.otherElements.matching(identifier: "CoreAnimPatternView").count == 2)
    }
    
    func mainViewCheckSch2() {
        XCTAssert(app.otherElements["MainView"].exists)
        XCTAssert(app.otherElements["SliderCtrlViewSch2"].exists)
        XCTAssert(app.otherElements.matching(identifier: "SliderCtrlViewSch2").count == 2)
        XCTAssert(app.otherElements["CoreAnimPatternView"].exists)
        XCTAssert(app.otherElements.matching(identifier: "CoreAnimPatternView").count == 2)
    }
    
    func dismissPopOver() {
//        app.otherElements["PopoverDismissRegion"].tap()
//        app.otherElements["dismiss popup"].tap()
//        app.windows.element(boundBy: 0).tap()
        app.swipeDown()
    }
    
    func testScheme1Basics() throws {
        app = XCUIApplication()
        app.tables.cells.staticTexts["Fill Ratio and Scale Factor"].tap()
        self.mainViewCheckSch1()
        app.buttons["SaveFilesButton"].tap()
        XCTAssert(app.collectionViews.cells.count >= 1)
        self.dismissPopOver()
        self.mainViewCheckSch1()
        app.buttons["SettingsButton"].tap()
        self.dismissPopOver()
        self.mainViewCheckSch1()
        app.buttons["SettingsButton"].tap()
        app.tables.cells.staticTexts["Fill Ratio and Scale Factor"].tap()
        self.dismissPopOver()
        self.mainViewCheckSch1()
        app.buttons["SettingsButton"].tap()
        app.tables.cells.staticTexts["Black Width and White Width"].tap()
        self.mainViewCheckSch2()
    }
    
    func testScheme2Basics() throws {
        app = XCUIApplication()
        app.tables.cells.staticTexts["Black Width and White Width"].tap()
        self.mainViewCheckSch2()
        app.buttons["SaveFilesButton"].tap()
        XCTAssert(app.collectionViews.cells.count >= 1)
        self.dismissPopOver()
        self.mainViewCheckSch2()
        app.buttons["SettingsButton"].tap()
        self.dismissPopOver()
        self.mainViewCheckSch2()
        app.buttons["SettingsButton"].tap()
        app.tables.cells.staticTexts["Fill Ratio and Scale Factor"].tap()
        self.dismissPopOver()
        self.mainViewCheckSch1()
        app.buttons["SettingsButton"].tap()
        app.tables.cells.staticTexts["Black Width and White Width"].tap()
        self.mainViewCheckSch2()
    }
    
    func testSaveFilePicker() throws {
        app = XCUIApplication()
        app.tables.cells.staticTexts["Fill Ratio and Scale Factor"].tap()
        app.buttons["SaveFilesButton"].tap()
        let numOfCells = app.collectionViews.cells.count
        XCTAssert(numOfCells >= 1)
        app.collectionViews.children(matching: .any).element(boundBy: numOfCells - 1).tap()
        self.mainViewCheckSch1()
        app.buttons["SaveFilesButton"].tap()
        XCTAssert(app.collectionViews.cells.count == numOfCells + 1)
    }
}
