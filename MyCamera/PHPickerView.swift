//
//  PHPickerView.swift
//  MyCamera
//
//  Created by 伊藤浩之 on 2022/08/08.
//

import SwiftUI
import PhotosUI

struct PHPickerView: UIViewControllerRepresentable {
    
    //フォトライブラリー画面(Sheet)の開閉状態を管理
    @Binding var isShowSheet: Bool
    //フォトライブラリーから読み込む写真
    @Binding var captureImage: UIImage?
    
    //Coordinatorでコントローラーのdelegateを管理
    class Coordinator: NSObject,
                       PHPickerViewControllerDelegate{
        //phpiclerView型の変数を用意
        var parent: PHPickerView
        
        //イニシャライズ
        init(parent: PHPickerView) {
            self.parent = parent
        }
        //フォトライブラリーで写真を選択・キャンセルした時に実行される
        //delegateメソッド、必ず必要
        func picker(
            _ picker: PHPickerViewController,
            didFinishPicking results: [PHPickerResult]) {
                
                //写真は1つだけ選べる設定なので最初の１件を指定
                //results.firstで最初の１枚目の写真情報を取得
                
                if let result = results.first {
                    //UIImage型の写真のみ非同期で取得
                    result.itemProvider.loadObject(ofClass: UIImage.self) {
                        (image, error) in
                        //写真が取得できたら
                        if let unwrapImage = image as? UIImage {
                            //選択された写真を追加する
                            self.parent.captureImage = unwrapImage
                        } else {
                            print("使用できる写真がないです")
                        }
                    }
                    //sheetを閉じない
                    parent.isShowSheet = true
                } else {
                    print("選択された写真はないです")
                    //Sheetを閉じる
                    parent.isShowSheet = false
                }
            }//pickerここまで
    }//coordinatorここまで
    
    //Coordinatorを生成、SwiftUIによって自動的に呼び出し
    func makeCoordinator() -> Coordinator {
        //Coordinatatorクラスのインスタンスを生成
        Coordinator(parent: self)
    }
    //Viewを生成する時に実行
    func makeUIViewController(
        context: UIViewControllerRepresentableContext<PHPickerView>)
    -> PHPickerViewController {
        //PHPickerViewControllerのカスタマイズ
        var configuration = PHPickerConfiguration()
        //静止画を選択
        configuration.filter = .images
        //フォトライブラリーで選択できる枚数を１枚にする
        configuration.selectionLimit = 1
        //PHPiclerViewControllerのインスタンスを生成
        let picker = PHPickerViewController(configuration: configuration)
        //delegateの設定
        picker.delegate = context.coordinator
        //PHPickerViewControllerを返す
        return picker
    }
    
    //Viewが更新された時に実行
    func updateUIViewController(
        _ uiViewController: PHPickerViewController,
        context: UIViewControllerRepresentableContext<PHPickerView>) {
        //処理なし
            
    }
    
}//PHPickerViewここまで
