//
//  ActivityView.swift
//  MyCamera
//
//  Created by 伊藤浩之 on 2022/08/04.
//

import SwiftUI

struct ActivityView: UIViewControllerRepresentable {
    let shareItems: [Any]
    
    func makeUIViewController(context: Context) ->
        UIActivityViewController{
            
            let controller = UIActivityViewController(
                activityItems: shareItems,
                applicationActivities: nil)
            return controller
    }
    func updateUIViewController(
        _ uiViewController: UIActivityViewController,
        context: UIViewControllerRepresentableContext<ActivityView>)
    {
        //処理なし
    }
   
}
