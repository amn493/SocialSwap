//
//  Animator.swift
//  SocialSwap
//
//  Created by DAYE JACK on 5/2/20.
//  Copyright © 2020 Daye Jack, Ashley Nussbaum, Jonathan Sussman. All rights reserved.
//

import Foundation
import UIKit

// Animation logic inspired by:
// https://www.vadimbulavin.com/tableviewcell-display-animation/
typealias  Animation = (UITableViewCell, IndexPath, UITableView) -> Void

// Animator - a class for creating table view animations
class Animator {
    var allCellsAnimated = false
    let animation: Animation
    
    //init - inits with a slide up table view cell animation
    init(){
        self.animation = { cell, indexPath, tableView in
            cell.transform = CGAffineTransform(translationX: 0, y: 30)
            
            UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.1, options: [.curveEaseOut], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
            }, completion: nil )
        }
    }
    
    //animate - takes a cell, an indexPath and a tableView as arguments
    // animates a specified table cell, using our animators animatioin
    func animate(cell: UITableViewCell, indexPath: IndexPath, tableView: UITableView){
        if(allCellsAnimated){
            return
        }
        
        animation(cell, indexPath, tableView)
        
        allCellsAnimated = tableView.isLastVisibleCell(at: indexPath)
    }
    
    
}

extension UITableView{
    //credits to: https://stackoverflow.com/questions/44757723/how-to-detect-last-visible-cell-in-uitableview
    //isLastVisibleCell - check if the passed in IndexPath is the lastVisible cell
    // return true if so, false otherwise
    func isLastVisibleCell(at indexPath: IndexPath) -> Bool {
        guard let lastIndexPath = indexPathsForVisibleRows?.last else {
            return false
        }
        return lastIndexPath == indexPath
    }
}
