//
//  OrderCell.swift
//  AppDATN
//
//  Created by Toan Tran on 27/12/2022.
//

import UIKit

protocol OrderCellDelegate: AnyObject {
    func reload()
}
class OrderCell: UITableViewCell {
    @IBOutlet weak var viewOrderDetail: UIView!
    @IBOutlet weak var showDeliverView: UIView!
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var idOrderLb: UILabel!
    @IBOutlet weak var dateOrderLb: UILabel!
    @IBOutlet weak var countProductLb: UILabel!
    @IBOutlet weak var totalOrder: UILabel!
    weak var delegate: OrderCellDelegate?
    weak var orderViewController: MyOrderViewController?
    static let identifier = "OrderCell"
    static func nib() -> UINib {
        return UINib(nibName: OrderCell.identifier, bundle: .main)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setImageBtn()
        viewOrderDetail.isHidden = true
        showDeliverView.isHidden = true
        self.orderViewController?.orderTableView.beginUpdates()
        self.orderViewController?.orderTableView.endUpdates()
    }
    func initializeViewController(orderViewController:MyOrderViewController) {
        self.orderViewController = orderViewController
    }
    func setImageBtn() {
        showButton.setImage(UIImage(systemName: "arrow.down.circle"), for: .normal)
        showButton.setImage(UIImage(systemName: "arrow.up.circle"), for: .selected)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func configure(order: OrderModel) {
        idOrderLb.text = "Order(\(order._id ?? ""))"
        countProductLb.text = "Items: \(order.details?.count ?? 0)"
        totalOrder.text = "Total: \(order.amount ?? 0) VND"
    }
    
    @IBAction func showDetail(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            viewOrderDetail.isHidden = false
        } else {
            viewOrderDetail.isHidden = true
        }
        self.orderViewController?.orderTableView.beginUpdates()
        self.orderViewController?.orderTableView.endUpdates()
        self.delegate?.reload()
    }
}
