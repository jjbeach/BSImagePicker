// The MIT License (MIT)
//
// Copyright (c) 2020 Joshua Beach
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Photos

extension PHAsset {
    func fetchImgDataOnSelect(callBackStart: @escaping () -> Void, callBackEnd: @escaping () -> Void) {
        let manager = PHCachingImageManager()
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = false
        options.isNetworkAccessAllowed = true
        options.progressHandler = { (progress, error, stop, info) in
            print("Asset download progress is at \(progress)")
            DispatchQueue.main.async{
              callBackStart()
            }
        }
        manager.requestImage(for: self, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: options) { (image, info) in
            guard image != nil else
            {
                if let isIniCloud = info?[PHImageResultIsInCloudKey] as? NSNumber, isIniCloud.boolValue == true
                {
                }
                return
            }
            callBackEnd()
        }
    }
}
