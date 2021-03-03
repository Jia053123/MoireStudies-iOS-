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
    
    private func moireViewCheckMetal() {
        let patternViewId = "MetalPatternView"
        XCTAssert(app.otherElements["MoireView"].exists)
        XCTAssert(app.otherElements[patternViewId].exists)
    }
    
    private func moireViewCheckCoreAnim() {
        let patternViewId = "CoreAnimPatternView"
        XCTAssert(app.otherElements["MoireView"].exists)
        XCTAssert(app.otherElements[patternViewId].exists)
    }
    
    private func controlViewsCheckSch1() {
        XCTAssert(app.otherElements["SliderCtrlViewSch1"].exists)
    }
    
    private func controlViewsCheckSch2() {
        XCTAssert(app.otherElements["SliderCtrlViewSch2"].exists)
    }
    
    private func controlViewsCheckSch3() {
        XCTAssert(app.otherElements["SliderCtrlViewSch3"].exists)
    }
    
    private func dismissPopOver() {
//        app.otherElements["PopoverDismissRegion"].tap()
//        app.otherElements["dismiss popup"].tap()
//        app.windows.element(boundBy: 0).tap()
        app.swipeDown()
    }
    
    func testScheme1OpeningControllers() throws {
        app = XCUIApplication()
        app.tables.cells.staticTexts["Fill Ratio and Scale Factor"].tap()
        app.buttons["SettingsDoneButton"].tap()
        self.moireViewCheckMetal()
        self.controlViewsCheckSch1()
        app.buttons["SaveFilesButton"].tap()
        XCTAssert(app.collectionViews.cells.count >= 1)
        self.dismissPopOver()
        self.moireViewCheckMetal()
        self.controlViewsCheckSch1()
        app.buttons["SettingsButton"].tap()
        self.dismissPopOver()
        self.moireViewCheckMetal()
        self.controlViewsCheckSch1()
        app.buttons["SettingsButton"].tap()
        app.tables.cells.staticTexts["Fill Ratio and Scale Factor"].tap()
        app.buttons["SettingsDoneButton"].tap()
        self.dismissPopOver()
        self.moireViewCheckMetal()
        self.controlViewsCheckSch1()
        app.buttons["SettingsButton"].tap()
        app.tables.cells.staticTexts["Black Width and White Width"].tap()
        app.buttons["SettingsDoneButton"].tap()
        self.moireViewCheckMetal()
        self.controlViewsCheckSch2()
    }
    
    func testScheme2OpeningControllers() throws {
        app = XCUIApplication()
        app.tables.cells.staticTexts["Black Width and White Width"].tap()
        app.buttons["SettingsDoneButton"].tap()
        self.moireViewCheckMetal()
        self.controlViewsCheckSch2()
        app.buttons["SaveFilesButton"].tap()
        XCTAssert(app.collectionViews.cells.count >= 1)
        self.dismissPopOver()
        self.moireViewCheckMetal()
        self.controlViewsCheckSch2()
        app.buttons["SettingsButton"].tap()
        self.dismissPopOver()
        self.moireViewCheckMetal()
        self.controlViewsCheckSch2()
        app.buttons["SettingsButton"].tap()
        app.tables.cells.staticTexts["Fill Ratio and Scale Factor"].tap()
        app.buttons["SettingsDoneButton"].tap()
        self.dismissPopOver()
        self.moireViewCheckMetal()
        self.controlViewsCheckSch1()
        app.buttons["SettingsButton"].tap()
        app.tables.cells.staticTexts["Black Width and White Width"].tap()
        app.buttons["SettingsDoneButton"].tap()
        self.moireViewCheckMetal()
        self.controlViewsCheckSch2()
    }
    
    private func saveFilePickerCheck()  {
        let numOfCells = app.collectionViews.cells.count
        XCTAssert(numOfCells >= 2)
        XCTAssert(app.collectionViews.cells.containing(.image, identifier:"Add Slide").children(matching: .other).element.exists)
    }
    
    func testSaveFilePicker() throws {
        var numOfCells: Int
        app = XCUIApplication()
        app.tables.cells.staticTexts["Fill Ratio and Scale Factor"].tap()
        app.buttons["SettingsDoneButton"].tap()
        // delete all
        app.buttons["SaveFilesButton"].tap()
        self.saveFilePickerCheck()
        numOfCells = app.collectionViews.cells.count
        for _ in 0..<numOfCells - 1 {
            app.buttons["DeleteButton"].tap()
        }
        self.moireViewCheckMetal()
        self.controlViewsCheckSch1()
        app.buttons["SaveFilesButton"].tap()
        XCTAssert(app.collectionViews.cells.count == 2)
        self.dismissPopOver()
        // create new
        app.buttons["SaveFilesButton"].tap()
        self.saveFilePickerCheck()
        app.collectionViews.cells.containing(.image, identifier:"Add Slide").children(matching: .other).element.tap()
        self.moireViewCheckMetal()
        self.controlViewsCheckSch1()
        app.buttons["SaveFilesButton"].tap()
        XCTAssert(app.collectionViews.cells.count == 3)
        self.dismissPopOver()
        // load: would need a title for each save file and the a label for the main view to be effective
        app.buttons["SaveFilesButton"].tap()
        self.saveFilePickerCheck()
        numOfCells = app.collectionViews.cells.count
        app.collectionViews.children(matching: .any).element(boundBy: 0).tap()
        app.buttons["LoadButton"].tap()
        self.moireViewCheckMetal()
        self.controlViewsCheckSch1()
        app.buttons["SaveFilesButton"].tap()
        XCTAssert(numOfCells == app.collectionViews.cells.count)
        self.dismissPopOver()
    }
    
    func testSettingsPanelStartupSingleSelection() throws {
        app = XCUIApplication()
        app.tables.cells.staticTexts["Fill Ratio and Scale Factor"].tap()
        app.tables.cells.staticTexts["Metal"].tap()
        app.buttons["SettingsDoneButton"].tap()
        self.moireViewCheckMetal()
        self.controlViewsCheckSch1()
    }
    
    func testSettingsPanelStartupMultipleSelections() throws {
        app = XCUIApplication()
        app.tables.cells.staticTexts["Fill Ratio and Scale Factor"].tap()
        app.tables.cells.staticTexts["Black Width and White Width"].tap()
        app.tables.cells.staticTexts["Black Width and White Width"].tap()
        app.tables.cells.staticTexts["Core Animation"].tap()
        app.tables.cells.staticTexts["Core Animation"].tap()
        app.tables.cells.staticTexts["Metal"].tap()
        app.tables.cells.staticTexts["Core Animation"].tap()
        app.tables.cells.staticTexts["Metal"].tap()
        app.tables.cells.staticTexts["Fill Ratio and Scale Factor"].tap()
        app.tables.cells.staticTexts["Fill Ratio and Scale Factor"].tap()
        app.buttons["SettingsDoneButton"].tap()
        self.moireViewCheckMetal()
        self.controlViewsCheckSch1()
    }
    
    func testSettingsPanelStartupPartialSelectionControlScheme() throws {
        app = XCUIApplication()
        app.tables.cells.staticTexts["Black Width and White Width"].tap()
        app.buttons["SettingsDoneButton"].tap()
        self.moireViewCheckMetal()
        self.controlViewsCheckSch2()
    }
    
    func testSettingsPanelStartupPartialSelectionRenderMethod() throws {
        app = XCUIApplication()
        app.tables.cells.staticTexts["Core Animation"].tap()
        app.buttons["SettingsDoneButton"].tap()
        self.moireViewCheckCoreAnim()
        self.controlViewsCheckSch1()
    }
    
    func testSettingsPanelStartupNoSelection() throws {
        app = XCUIApplication()
        app.buttons["SettingsDoneButton"].tap()
        self.moireViewCheckMetal()
        self.controlViewsCheckSch3()
    }
    
    func testSettingsPanel() throws {
        app = XCUIApplication()
        app.tables.cells.staticTexts["Fill Ratio and Scale Factor"].tap()
        app.tables.cells.staticTexts["Metal"].tap()
        app.buttons["SettingsDoneButton"].tap()
        self.moireViewCheckMetal()
        self.controlViewsCheckSch1()
        app.buttons["SettingsButton"].tap()
        app.tables.cells.staticTexts["Black Width and White Width"].tap()
        app.tables.cells.staticTexts["Core Animation"].tap()
        self.dismissPopOver()
        self.moireViewCheckCoreAnim()
        self.controlViewsCheckSch2()
        app.buttons["SettingsButton"].tap()
        app.tables.cells.staticTexts["Fill Ratio and Scale Factor"].tap()
        app.tables.cells.staticTexts["Black Width and White Width"].tap()
        app.tables.cells.staticTexts["Black Width and White Width"].tap()
        app.tables.cells.staticTexts["Core Animation"].tap()
        app.tables.cells.staticTexts["Core Animation"].tap()
        app.tables.cells.staticTexts["Metal"].tap()
        app.tables.cells.staticTexts["Core Animation"].tap()
        app.tables.cells.staticTexts["Metal"].tap()
        app.tables.cells.staticTexts["Fill Ratio and Scale Factor"].tap()
        app.tables.cells.staticTexts["Fill Ratio and Scale Factor"].tap()
        app.buttons["SettingsDoneButton"].tap()
        self.moireViewCheckMetal()
        self.controlViewsCheckSch1()
        app.buttons["SettingsButton"].tap()
        app.tables.cells.staticTexts["Fill Ratio and Scale Factor"].tap()
        app.tables.cells.staticTexts["Fill Ratio and Scale Factor"].tap()
        app.tables.cells.staticTexts["Core Animation"].tap()
        app.tables.cells.staticTexts["Black Width and White Width"].tap()
        app.tables.cells.staticTexts["Metal"].tap()
        app.tables.cells.staticTexts["Metal"].tap()
        app.tables.cells.staticTexts["Fill Ratio and Scale Factor"].tap()
        self.dismissPopOver()
        self.moireViewCheckMetal()
        self.controlViewsCheckSch1()
        app.buttons["SettingsButton"].tap()
        app.tables.cells.staticTexts["Core Animation"].tap()
        app.buttons["SettingsDoneButton"].tap()
        self.moireViewCheckCoreAnim()
        self.controlViewsCheckSch1()
        // for scheme3
        app.buttons["SettingsButton"].tap()
        app.tables.cells.staticTexts["Fill Ratio and Scale Factor"].tap()
        app.tables.cells.staticTexts["Core Animation"].tap()
        app.tables.cells.staticTexts["Composite Controls (Metal Only)"].tap()
        self.dismissPopOver()
        self.moireViewCheckMetal()
        self.controlViewsCheckSch3()
        app.buttons["SettingsButton"].tap()
        app.tables.cells.staticTexts["Fill Ratio and Scale Factor"].tap()
        app.tables.cells.staticTexts["Composite Controls (Metal Only)"].tap()
        app.tables.cells.staticTexts["Core Animation"].tap()
        self.dismissPopOver()
        self.moireViewCheckCoreAnim()
        self.controlViewsCheckSch1()
        app.buttons["SettingsButton"].tap()
        app.tables.cells.staticTexts["Composite Controls (Metal Only)"].tap()
        app.tables.cells.staticTexts["Core Animation"].tap()
        app.tables.cells.staticTexts["Black Width and White Width"].tap()
        app.tables.cells.staticTexts["Composite Controls (Metal Only)"].tap()
        self.dismissPopOver()
        self.moireViewCheckMetal()
        self.controlViewsCheckSch3()
    }
}
