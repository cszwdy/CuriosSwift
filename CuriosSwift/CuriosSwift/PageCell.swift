//
//  PageCell.swift
//  CuriosSwift
//
//  Created by Emiaostein on 4/20/15.
//  Copyright (c) 2015 botai. All rights reserved.
//

import UIKit

class PageCell: UICollectionViewCell {
    
    var containerNode: ASDisplayNode?
    var containerNodeView: UIView?
    var nodeConstructionOperation: NSOperation?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if let operation = nodeConstructionOperation {
            operation.cancel()
        }
        
        containerNode?.recursivelySetDisplaySuspended(true)
        containerNodeView?.removeFromSuperview()
        containerNodeView = nil
        containerNode = nil
    }
    
    func configCell(cellVM: PageModel, queue: NSOperationQueue) {
        
        if let oldOperation = nodeConstructionOperation {
            oldOperation.cancel()
        }
        
        let newOperation = configCellTaskBy(cellVM, queue: queue)
        nodeConstructionOperation = newOperation
        queue.addOperation(newOperation)
    }
}

// MARK - private
extension PageCell {
    
    private func configCellTaskBy(cellVM: PageModel, queue: NSOperationQueue) -> NSOperation {
        
        let operation = NSBlockOperation()
        operation.addExecutionBlock { [weak self, unowned operation] in
            
            if operation.cancelled {
                return
            }
            
            if let strongSelf = self {
                
                let aContaierNode = strongSelf.renderNodesBy(cellVM)
                aContaierNode.backgroundColor = UIColor.orangeColor()
                
                if operation.cancelled {
                    return
                }
                dispatch_async(dispatch_get_main_queue(), { [weak operation] in
                    if let strongOperation = operation{
                        if strongOperation.cancelled{
                            return
                        }
                        
                        if strongSelf.nodeConstructionOperation != operation {
                            return
                        }
                        
                        if aContaierNode.displaySuspended {
                            return
                        }
                        
                        strongSelf.contentView.addSubview(aContaierNode.view)
                        aContaierNode.setNeedsDisplay()
                        strongSelf.containerNodeView = aContaierNode.view
                        strongSelf.containerNode = aContaierNode
//                        println("end")
                    }
                    })
            }
        }
        return operation
    }
    
    private func renderNodesBy(cellVM: PageModel) -> ASDisplayNode {
        
        func getAspectRatio(cellVM: PageModel) -> CGFloat {
            let normalWidth = LayoutSpec.layoutConstants.normalLayout.itemSize.width
            let normalHeight = LayoutSpec.layoutConstants.normalLayout.itemSize.height
            return min(normalWidth / cellVM.width, normalHeight / cellVM.height)
        }
        
        func getNodeFrame(cellVM: PageModel, aspectRatio: CGFloat) -> CGRect {
            let normalWidth = LayoutSpec.layoutConstants.normalLayout.itemSize.width
            let normalHeight = LayoutSpec.layoutConstants.normalLayout.itemSize.height
            let nodeWidth = cellVM.width * aspectRatio
            let nodeHeight = cellVM.height * aspectRatio
            let x = (normalWidth - nodeWidth) / 2.0
            let y = (normalHeight - nodeHeight) / 2.0
            
            return CGRectMake(x, y, nodeWidth, nodeHeight)
        }
        
        let aspectRatio = getAspectRatio(cellVM)
        let nodeFrome = getNodeFrame(cellVM, aspectRatio)
        let aContainerNode = ASDisplayNode()
        aContainerNode.layerBacked = false
        aContainerNode.frame = nodeFrome
        aContainerNode.userInteractionEnabled = true
        let containerModels = cellVM.containers
        
        for containerM in containerModels {
            
            let containtVM = ContainerViewModel(model: containerM, aspectRatio:aspectRatio)
            let node = CUEditableTextNode(viewModel: containtVM)
            node.backgroundColor = UIColor.lightGrayColor()
            aContainerNode.addSubnode(node)
        }
        
        return aContainerNode
    }
}
