//
//  ViewController.swift
//  Onde estou
//
//  Created by Bruno Lopes de Mello on 05/11/2017.
//  Copyright © 2017 Bruno Lopes de Mello. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapa: MKMapView!
    @IBOutlet weak var lblVelocidade: UILabel!
    @IBOutlet weak var lblLatitude: UILabel!
    @IBOutlet weak var lblLongitude: UILabel!
    @IBOutlet weak var lblEndereco: UILabel!
    
    
    
    var gerenciadorLocalizacao = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        gerenciadorLocalizacao.delegate = self
        gerenciadorLocalizacao.desiredAccuracy = kCLLocationAccuracyBest
        gerenciadorLocalizacao.requestWhenInUseAuthorization()
        gerenciadorLocalizacao.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        let localizaUsuario = locations.last!
        let latitude : CLLocationDegrees = (locations.last?.coordinate.latitude)!
        let longitude : CLLocationDegrees = (locations.last?.coordinate.longitude)!
        let deltaLatitude : CLLocationDegrees = 0.003
        let deltaLongitude : CLLocationDegrees = 0.003
        
        let aproximacao : MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: deltaLatitude, longitudeDelta: deltaLongitude)
        let coordenadas : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let regiao : MKCoordinateRegion = MKCoordinateRegion(center: coordenadas, span: aproximacao)
        
        mapa.setRegion(regiao, animated: true)
        
        lblLatitude.text = String(latitude)
        lblLongitude.text = String(longitude)
        if localizaUsuario.speed > 0 {
            lblVelocidade.text = String(describing: locations.last!.speed)
        }
        
        CLGeocoder().reverseGeocodeLocation(localizaUsuario) { (detalhesLocal, erro) in
            if erro == nil {
                
                if let _dadosLocal = detalhesLocal?.first {
                    let rua = _dadosLocal.thoroughfare
                    let numero = _dadosLocal.subThoroughfare
                    let estado = _dadosLocal.locality
                    let cidade = _dadosLocal.subLocality
                    let codigoPostal = _dadosLocal.postalCode
                    let pais = _dadosLocal.country
                    let uf = _dadosLocal.administrativeArea
                    let subUf = _dadosLocal.subAdministrativeArea
                    
                    
                    print("\n / rua: \(rua)\n / numero: \(numero)\n / estado: \(estado)\n / cidade: \(cidade)\n / CEP: \(codigoPostal)" +
                        "\n / pais: \(pais)\n / uf: \(uf)\n / subUf: \(subUf)")
                    
                    self.lblEndereco.text = "\(rua) - \(numero) - \(estado) - \(cidade) - \(pais)"
                    
                }
                
            } else {
                print(erro)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status != .authorizedWhenInUse {
            let Alerta = UIAlertController(title: "Permissao de localizacao", message: "Necessario permissao para acesso a" +
                " sua localizacao!! por favor habilite", preferredStyle: UIAlertControllerStyle.alert)
            
            let acoesConfiguracoes = UIAlertAction(title: "Abrir configuracoes", style: UIAlertActionStyle.default,
                                                   handler: { (alertaConfiguracoes) in
                                                    
                                                    if let configuracoes = NSURL(string: UIApplicationOpenSettingsURLString) {
                                                        UIApplication.shared.open(configuracoes as URL)
                                                    }
            })
            
            let cancelar = UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.destructive, handler: nil)
            
            Alerta.addAction(acoesConfiguracoes)
            Alerta.addAction(cancelar)
            
            present(Alerta, animated: true, completion: nil)
        }
    }
    
    //Esconde a barra de status
    override var prefersStatusBarHidden: Bool {
        get {
                return true
        }
    }

}

