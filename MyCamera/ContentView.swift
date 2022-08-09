//
//  ContentView.swift
//  MyCamera
//
//  Created by 伊藤浩之 on 2022/07/28.
//

import SwiftUI

struct ContentView: View {
    //撮影した写真を保持する状態変数
    @State var captureImage: UIImage? = nil
    //撮影画面（sheet）の開閉状態を管理
    @State var isShowSheet = false
    //シェア画面の（Sheet）の開閉状態を管理
    @State var isShowActivity = false
    //フォトライブラリーかカメラかを保持する状態変数
    @State var isPhotolibrary = false
    //選択画面(ActionSheet)のSheet開閉ぞゆたいを管理
    @State var isShowAction = false
    
    
    var body: some View {
        VStack{
            //スペースを追加
            Spacer()
            //撮影した写真があるとき
            if let unwrapCaptureImage = captureImage{
                //撮影写真を表示
                Image(uiImage: unwrapCaptureImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            
            //スペースを追加
            Spacer()
            Button(action: {
                //ボタンをタップしたときのアクション
                //カメラが利用可能かチェックする
                if UIImagePickerController.isSourceTypeAvailable(.camera)
                {
                    print("カメラは利用できます")
                    //カメラが使えるなら
                    isShowAction = true
                }else {
                    print("カメラは利用できません")
                }
            }){
                //テキスト表示
                Text("カメラを起動する")
                    //横幅いっぱい
                    .frame(maxWidth: .infinity)
                    //高さ５０ポイントを指定
                    .frame(height: 50)
                    //文字列をセンタリング指定
                    .multilineTextAlignment(.center)
                    //背景を青色に指定
                    .background(Color.blue)
                    //文字色を白色に指定
                    .foregroundColor(Color.white)
            }
            .padding()
            //sheetを表示
            //isPresentedで指定した状態変数がtrueのとき実行
            .sheet(isPresented: $isShowSheet) {
                //フォトライブラリーが選択された
                if isPhotolibrary {
                    //PHPickerViewController（フォトライブラリー）を表示
                    PHPickerView(isShowSheet: $isShowSheet, captureImage: $captureImage)
                }else {
                    //UIImagePickerController(写真撮影)を表示
                    ImagePickerView(isShowSheet: $isShowSheet, captureImage: $captureImage)
                }
            }
            
            //状態変数：＄isShowActionに変化があったら実行
            .actionSheet(isPresented: $isShowAction) {
                //ActionSheetを表示する
                ActionSheet(title: Text("確認"),
                            message: Text("選択してください"),
                            buttons: [
                                .default(Text("カメラ"), action:{
                                    isPhotolibrary = false
                                    //カメラが利用可能かチェック
                                    if UIImagePickerController.isSourceTypeAvailable(.camera) {
                                        print("カメラは利用できます")
                                        //カメラが使えるならisShowSheetをtrue
                                        isShowSheet = true
                                    } else {
                                        print("カメラは利用できません")
                                    }
                                }),
                                .default(Text("フォトライブラリー"), action: {
                                    isPhotolibrary = true
                                    //isShowSheetをtrue
                                    isShowSheet = true
                                }),
                                .cancel(),
                            ])//ActionSheetここまで
            }//.actionSheetここまで
            
                
            
            Button(action: {
                //ボタンをタップしたときのアクション
                //撮影した写真があるときだけ
                //UIActivityViewController(シェア機能)表示
                if let _ = captureImage {
                    isShowActivity = true
                }
                
            }) {
                Text("SNSに投稿する")
                    //横幅いっぱい
                    .frame(maxWidth: .infinity)
                    //高さ５０ポイントを指定
                    .frame(height: 50)
                    //文字列をセンタリング指定
                    .multilineTextAlignment(.center)
                    //背景を青色に指定
                    .background(Color.blue)
                    //文字色を白色に指定
                    .foregroundColor(Color.white)
            }
            .padding()
                //sheetを表示
                //isPresentedで指定した状態変数がtrueのとき実行
            .sheet(isPresented: $isShowActivity) {
                //UIActivityViewController（シャア機能）を表示
                ActivityView(shareItems: [captureImage!])
            }
            
           
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
