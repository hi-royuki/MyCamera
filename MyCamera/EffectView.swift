//
//  EffectView.swift
//  MyCamera
//
//  Created by 伊藤浩之 on 2022/08/09.
//

import SwiftUI

struct EffectView: View {
    //エフェクト編集画面（Sheet）の開閉状態を管理
    @Binding var isShowSheet: Bool
    //撮影した写真
    let captureImage: UIImage
    //表示する写真
    @State var showImage: UIImage?
    //シェア画面（Sheet）の開閉状態を管理
    @State var isShowActivity = false
    
    
    var body: some View {
        //縦方向にレイアウト
        VStack{
            //スペース追加
            Spacer()
            
            if let unwrapShowImage = showImage {
                //表示する写真がある場合は画面に表示
                Image(uiImage:  unwrapShowImage)
                //リサイズする
                    .resizable()
                //アスペクト比（縦横比）を維持して画面内に収まるようにする
                    .aspectRatio(contentMode: .fit)
            }
            //スペース追加
            Spacer()
            //エフェクトボタン
            Button(action: {
                //ボタンをタップしたときのアクション
                //フィルタ名を指定
                let filterName = "CIphotoEffectMono"
                //元の画像の回転角度を取得
                let rotate = captureImage.imageOrientation
                //UIImage形式の画像をCIImage形式に変換
                let inputImage = CIImage(image: captureImage)
                //フィルタの種別を引数で指定された種類を指定してCIFilterのインスタンスを取得
                guard let effectFilter = CIFilter(name: filterName) else {
                    return
                }
                //フィルタ加工のパラメータを初期化
                effectFilter.setDefaults()
                //インスタンスにフィルタ加工する元画像を設定
                effectFilter.setValue(inputImage, forKey: kCIInputImageKey)
                //フィルタ加工を行う情報を生成
                guard let outputImage = effectFilter.outputImage else{
                    return
                }
                //CIContextのインスタンスを取得
                let ciContext = CIContext(options: nil)
                //フィルタ加工後の画像をCIContext上に描写し、結果をcgImageとしてCGImage形式の画像を取得
                guard let cgImage = ciContext.createCGImage(outputImage, from: outputImage.extent)
                else {
                    return
                }
                //フィルタ加工後の画像をCGImage形式からUIImage形式へ変更、その際に回転角度を指定
                showImage = UIImage(cgImage: cgImage,scale: 1.0, orientation: rotate)
                
            }) {
                //テキストを表示する
                Text("エフェクト")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .multilineTextAlignment(.center)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
            }//エフェクトボタンここまで
            //スペース追加
            .padding()
            //「シェア」ボタン
            Button(action: {
                //ボタンをタップしたときのアクション
                //UIActivityViewControllerを表示する
                isShowActivity = true
            }) {
                //テキストを表示する
                Text("シェア")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .multilineTextAlignment(.center)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
            }//シェアボタンここまで
            .sheet(isPresented: $isShowActivity) {
                //UIActivityViewControllerを表示する
                ActivityView(shareItems: [showImage!])
            }
            //スペース追加
            .padding()
            //閉じるボタン
            Button(action: {
                //ボタンをタップしたときのアクション
                isShowSheet = false
            }){
                Text("閉じる")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .multilineTextAlignment(.center)
                    .background(Color.blue)
                    .foregroundColor(Color.white)
            }//閉じるボタンここまで
            .padding()
        }//VStackここまで
        //写真が表示される時に実行される
        .onAppear {
            //撮影した写真を表示する写真に設定
            showImage = captureImage
        } //.onAppearここまで
    }//bodyここまで
}//Viewここまで

struct EffectView_Previews: PreviewProvider {
    static var previews: some View {
        EffectView(isShowSheet: Binding.constant(true), captureImage: UIImage(named: "preview_use")!)
    }
}
