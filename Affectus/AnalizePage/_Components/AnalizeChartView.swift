//
//  AnalizeChartView.swift
//  Affectus
//
//  Created by Sezgin Çiftci on 6.08.2022.
//

import UIKit
import Charts

class AnalizeChartView: UIView, ChartViewDelegate {
    
    @IBOutlet weak var lineChartView: LineChartView!
    
    lazy var yValues = [
        ChartDataEntry(x: 0.0, y: 0.0),
        ChartDataEntry(x: 1.0, y: 2.0),
        ChartDataEntry(x: 2.0, y: 3.0),
        ChartDataEntry(x: 3.0, y: 4.0),
        ChartDataEntry(x: 4.0, y: 5.0),
        ChartDataEntry(x: 6.0, y: 8.0)
    ]
    
    lazy var yValues2 = [
        ChartDataEntry(x: 0.0, y: 3.0),
        ChartDataEntry(x: 1.0, y: 3.0),
        ChartDataEntry(x: 2.0, y: 3.0),
        ChartDataEntry(x: 3.0, y: 3.0),
        ChartDataEntry(x: 4.0, y: 3.0),
        ChartDataEntry(x: 5.0, y: 3.0),
        ChartDataEntry(x: 6.0, y: 3.0),
        ChartDataEntry(x: 7.0, y: 3.0)
    ]
    
    lazy var xValues = [ChartDataEntry]()
    
    var myNumber = 0
    
    var listData: AddNewEntityList?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        if let viewForXib = Bundle.main.loadNibNamed("AnalizeChartView", owner: self, options: nil)?[0] as? UIView {
            viewForXib.frame = self.bounds
            viewForXib.layer.cornerRadius = 16
            addSubview(viewForXib)
        }
        setChartDataWithCoreData()
        setupChartView()
    }
    
    func setupChartView() {
        
        lineChartView.backgroundColor = UIColor(named: "backgroundColour")
        lineChartView.rightAxis.enabled = false
        lineChartView.layer.cornerRadius = 20
        lineChartView.clipsToBounds = true
        
        let yAxis = lineChartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 8)
        yAxis.setLabelCount(5, force: false)
        yAxis.labelTextColor = UIColor(named: "cellGradientStartColour")!
        yAxis.axisLineColor = UIColor(named: "cellGradientStartColour")!
        yAxis.labelPosition = .insideChart
        
        lineChartView.xAxis.enabled = false
//        let xAxis = lineChartView.xAxis
//        xAxis.labelFont = .boldSystemFont(ofSize: 8)
//        xAxis.setLabelCount(6, force: false)
//        xAxis.labelTextColor = UIColor(named: "cellGradientEndColour")!
//        xAxis.axisLineColor = .white
//        xAxis.labelPosition = .topInside
        lineChartView.animate(xAxisDuration: 2.0)
        setDataSet()
    }
    
    func setDataSet() {
        let dataSet1 = LineChartDataSet(entries: xValues, label: "Test Entry")
        dataSet1.mode = .cubicBezier
        dataSet1.drawHorizontalHighlightIndicatorEnabled = false
        dataSet1.drawVerticalHighlightIndicatorEnabled = false
        dataSet1.drawCirclesEnabled = false
        dataSet1.lineWidth = 2
//        dataSet1.fill = Fill(CGColor: UIColor.secondarySystemBackground.cgColor)
//        dataSet1.fillAlpha = 0.5
//        dataSet1.drawFilledEnabled = true
        dataSet1.setColor(UIColor(named: "cellGradientStartColour")!)
        
        let dataSet2 = LineChartDataSet(entries: yValues2, label: "Test Entry")
        dataSet2.mode = .cubicBezier
        dataSet2.drawHorizontalHighlightIndicatorEnabled = false
        dataSet2.drawVerticalHighlightIndicatorEnabled = false
        dataSet2.drawCirclesEnabled = false
        dataSet2.lineWidth = 2
        dataSet2.lineDashLengths = [7]
        dataSet2.setColor(UIColor(named: "cellGradientEndColour")!)
        
        let data = LineChartData(dataSets: [dataSet1, dataSet2])
        data.setDrawValues(false)
        lineChartView.data = data
    }
    
    func setChartDataWithCoreData() {
        CoreDataManager.shared.loadData { addNewEntityList in
            self.listData = addNewEntityList
            guard let listData = listData else {
                return
            }
            for data in listData.moodEmojiArray {
                xValues.append(ChartDataEntry(x: Double(myNumber), y: Double(generateChartData(data))))
                myNumber += 1
            }
        }
    }
    
    func generateChartData(_ emojiIndex: Int) -> Int {
        switch emojiIndex {
        case 0:
            return 1
        case 1:
            return 2
        case 2:
            return 3
        case 3:
            return 4
        case 4:
            return 5
        default:
            return 0
        }
    }
}
