//
//  ViewController.swift
//  testMap
//
//  Created by carlos on 9/4/16.
//  Copyright © 2016 carlos. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate {
    
    var mainMapView : MKMapView!
    //定位管理器
    let locationManager:CLLocationManager = CLLocationManager()
    var currLocation : CLLocation!
    
    var objectAnnotation : MKPointAnnotation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // FIXME:
        
        self.mainMapView = MKMapView(frame:self.view.frame)
        self.view.addSubview(self.mainMapView)
        
        self.mainMapView.delegate = self
        
        self.locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //精确到1000米,距离过滤器，定义了设备移动后获得位置信息的最小距离
        locationManager.distanceFilter = kCLLocationAccuracyKilometer

        //如果是IOS8及以上版本需调用这个方法
        locationManager.requestAlwaysAuthorization()
        //使用应用程序期间允许访问位置数据
        locationManager.requestWhenInUseAuthorization();
        //启动定位
        locationManager.startUpdatingLocation()
        
        self.objectAnnotation = MKPointAnnotation()
        
        //创建一个MKCoordinateSpan对象，设置地图的范围（越小越精确）
        let latDelta = 0.05
        let longDelta = 0.05
        let currentLocationSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        
        //定义地图区域和中心坐标（
        //使用当前位置
        //let center:CLLocation = locationManager.location.coordinate
        //使用自定义位置
        
        //let center:CLLocation = CLLocation(latitude: 32.029171, longitude: 118.788231)
        //let currentRegion:MKCoordinateRegion = MKCoordinateRegion(center: center.coordinate,span: currentLocationSpan)
        
        //设置显示区域
        //self.mainMapView.setRegion(currentRegion, animated: true)
        
        /*
        //创建一个大头针对象
        let objectAnnotation = MKPointAnnotation()
        //设置大头针的显示位置
        objectAnnotation.coordinate = CLLocation(latitude: 32.029171,longitude: 118.788231).coordinate
        //设置点击大头针之后显示的标题
        objectAnnotation.title = "南京夫子庙"
        //设置点击大头针之后显示的描述
        objectAnnotation.subtitle = "南京市秦淮区秦淮河北岸中华路"
        //添加大头针
        self.mainMapView.addAnnotation(objectAnnotation)
 */
    }
    
    
    
    //FIXME: CoreLocationManagerDelegate 中获取到位置信息的处理函数
    func  locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location:CLLocation = locations[locations.count-1] as CLLocation
        currLocation=location
        if (location.horizontalAccuracy > 0) {
            self.locationManager.stopUpdatingLocation()
            print("wgs84坐标系  纬度: \(location.coordinate.latitude) 经度: \(location.coordinate.longitude)")
            self.locationManager.stopUpdatingLocation()
            print("结束定位")
        }
        
        
        //创建一个MKCoordinateSpan对象，设置地图的范围（越小越精确）
        let latDelta = 0.05
        let longDelta = 0.05
        let currentLocationSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        
        //定义地图区域和中心坐标（
        //使用当前位置
        let center:CLLocation = location
        //使用自定义位置
        
        //let center:CLLocation = CLLocation(latitude: 32.029171, longitude: 118.788231)
        let currentRegion:MKCoordinateRegion = MKCoordinateRegion(center: center.coordinate,span: currentLocationSpan)
        
        self.mainMapView.setRegion(currentRegion, animated: true)
        
        
        
        
        //使用坐标，获取地址
        let geocoder = CLGeocoder()
        var p:CLPlacemark?
        geocoder.reverseGeocodeLocation(currLocation, completionHandler: { (placemarks, error) -> Void in
            if error != nil {
                print("获取地址失败: \(error!.localizedDescription)")
                return
            }
            let pm = placemarks! as [CLPlacemark]
            if (pm.count > 0){
                p = placemarks![0] as CLPlacemark
                print("地址:\(p?.name!)")
                
                //创建一个大头针对象
                
                //设置大头针的显示位置
                self.objectAnnotation.coordinate = center.coordinate
                //设置点击大头针之后显示的标题
                self.objectAnnotation.title = p?.name!
                //设置点击大头针之后显示的描述
                //self.objectAnnotation.subtitle = "test"
                //添加大头针
                self.mainMapView.addAnnotation(self.objectAnnotation)
                
                
            }else{
                print("没地址!")
            }
        })
        
        

        

    }
    //FIXME:  获取位置信息失败
    func  locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    
    func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        print("地图缩放级别发送改变时")
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("地图缩放完毕触法")
    }
    
    func mapViewWillStartLoadingMap(mapView: MKMapView) {
        print("开始加载地图")
    }
    
    func mapViewDidFinishLoadingMap(mapView: MKMapView) {
        print("地图加载结束")
    }
    
    func mapViewDidFailLoadingMap(mapView: MKMapView, withError error: NSError) {
        print("地图加载失败")
    }
    
    func mapViewWillStartRenderingMap(mapView: MKMapView) {
        print("开始渲染下载的地图块")
    }
    
    func mapViewDidFinishRenderingMap(mapView: MKMapView, fullyRendered: Bool) {
        print("渲染下载的地图结束时调用")
    }
    
    func mapViewWillStartLocatingUser(mapView: MKMapView) {
        print("正在跟踪用户的位置")
    }
    
    func mapViewDidStopLocatingUser(mapView: MKMapView) {
        print("停止跟踪用户的位置")
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        print("更新用户的位置")
    }
    
    func mapView(mapView: MKMapView, didFailToLocateUserWithError error: NSError) {
        print("跟踪用户的位置失败")
    }
    
    func mapView(mapView: MKMapView, didChangeUserTrackingMode mode: MKUserTrackingMode,
                 animated: Bool) {
        print("改变UserTrackingMode")
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        print("设置overlay的渲染")
        return MKPolylineRenderer()
    }
    
    func mapView(mapView: MKMapView, didAddOverlayRenderers renderers: [MKOverlayRenderer]) {
        print("地图上加了overlayRenderers后调用")
    }
    
    /*** 下面是大头针标注相关 *****/
    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
        print("添加注释视图")
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        print("点击注释视图按钮")
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        print("点击大头针注释视图")
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        print("取消点击大头针注释视图")
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView,
                 didChangeDragState newState: MKAnnotationViewDragState,
                                    fromOldState oldState: MKAnnotationViewDragState) {
        print("移动annotation位置时调用")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

