//
//  MarketDataModel.swift
//  SwiftCryptoApp
//
//  Created by Syed Abrar Shah on 29/01/2025.
//

import Foundation
import SwiftUI

// URL: https://api.coingecko.com/api/v3/global

/* JSON RESPONSE:

{
"data": {
 "active_cryptocurrencies": 16993,
 "upcoming_icos": 0,
 "ongoing_icos": 49,
 "ended_icos": 3376,
 "markets": 1218,
 "total_market_cap": {
     "btc": 35304294.81043685,
     "eth": 1154935711.269396,
     "ltc": 31875352243.096184,
     "bch": 8745734203.1292,
     "bnb": 5395407264.659069,
     "eos": 4878888118927.08,
     "xrp": 1171641523351.5234,
     "xlm": 9130577974831.945,
     "link": 156150704472.12387,
     "dot": 628427262634.8599,
     "yfi": 508600369.4129824,
     "usd": 3614136657795.152,
     "aed": 13274561307932.0,
     "ars": 3795601375142051.5,
     "aud": 5801686837478.773,
     "bdt": 438774221184117.25,
     "bhd": 1362468079665.5906,
     "bmd": 3614136657795.152,
     "brl": 21182454951337.395,
     "cad": 5214736587706.207,
     "chf": 3273193462045.39,
     "clp": 3587319763794310.5,
     "cny": 26206827733004.22,
     "czk": 87210649946539.98,
     "dkk": 25905770149409.887,
     "eur": 3471533667688.531,
     "gbp": 2906734461491.593,
     "gel": 10390642891161.064,
     "hkd": 28156455682368.523,
     "huf": 1.41640482267261e+15,
     "idr": 5.8595667994656536e+16,
     "ils": 13029804745192.797,
     "inr": 312805313115679.56,
     "jpy": 561052250016968.25,
     "krw": 5.220227845503737e+15,
     "kwd": 1114520234257.5537,
     "lkr": 1072415740971756.2,
     "mmk": 7.582458708054231e+15,
     "mxn": 74140034370207.36,
     "myr": 15875095269365.213,
     "ngn": 5.611814554024846e+15,
     "nok": 40911889629048.15,
     "nzd": 6397777238858.898,
     "php": 211029414149702.4,
     "pkr": 1007038596554089.4,
     "pln": 14608824665120.156,
     "rub": 355189500823286.9,
     "sar": 13554443664848.314,
     "sek": 39796422490986.25,
     "sgd": 4882282998965.604,
     "thb": 121998797020533.2,
     "try": 129285951850552.31,
     "twd": 118642951867260.69,
     "uah": 151893081401709.28,
     "vef": 361883503545.0286,
     "vnd": 9.064807384060517e+16,
     "zar": 67585804769569.15,
     "xdr": 2760716112243.353,
     "xag": 118703716346.88821,
     "xau": 1307811490.9897542,
     "bits": 35304294810436.85,
     "sats": 3.530429481043685e+15
 },
 "total_volume": {
     "btc": 1272575.8880926797,
     "eth": 41630723.58052337,
     "ltc": 1148976488.7481456,
     "bch": 315248060.6206435,
     "bnb": 194482434.17159054,
     "eos": 175864024878.1569,
     "xrp": 42232899994.49434,
     "xlm": 329120109536.53845,
     "link": 5628596251.161084,
     "dot": 22652240645.033092,
     "yfi": 18332969.692929614,
     "usd": 130274891247.00813,
     "aed": 478493813180.155,
     "ars": 136815954454053.12,
     "aud": 209127156321.43234,
     "bdt": 15816021738819.223,
     "bhd": 49111419326.970894,
     "bmd": 130274891247.00813,
     "brl": 763541137598.715,
     "cad": 187969992883.35312,
     "chf": 117985279106.33044,
     "clp": 129308251553955.3,
     "cny": 944649291410.3059,
     "czk": 3143588362344.1973,
     "dkk": 933797392969.4302,
     "eur": 125134634863.07501,
     "gbp": 104775926233.44879,
     "gel": 374540312335.1485,
     "hkd": 1014925430119.0481,
     "huf": 51055619005835.266,
     "idr": 2.112134929675463e+15,
     "ils": 469671336995.1252,
     "inr": 11275356193224.836,
     "jpy": 20223646136125.86,
     "krw": 188167930338440.7,
     "kwd": 40173910412.96989,
     "lkr": 38656215095061.26,
     "mmk": 273316721836223.12,
     "mxn": 2672445961277.1104,
     "myr": 572232459802.4835,
     "ngn": 202283034634879.47,
     "nok": 1474706818470.2656,
     "nzd": 230613784959.475,
     "php": 7606749987988.569,
     "pkr": 36299635589225.02,
     "pln": 526588567255.8343,
     "rub": 12803133354692.174,
     "sar": 488582431033.2146,
     "sek": 1434498776035.7888,
     "sgd": 175986396462.21457,
     "thb": 4397559228934.009,
     "try": 4660231449956.222,
     "twd": 4276594693339.75,
     "uah": 5475126298310.051,
     "vef": 13044424860.562927,
     "vnd": 3267493478937768.5,
     "zar": 2436192706550.4434,
     "xdr": 99512560077.28717,
     "xag": 4278785005.086286,
     "xau": 47141272.14664238,
     "bits": 1272575888092.6797,
     "sats": 127257588809267.97
 },
 "market_cap_percentage": {
     "btc": 56.13002357475724,
     "eth": 10.439591020621455,
     "xrp": 4.920389618543279,
     "usdt": 3.85504356728441,
     "sol": 3.120125799995959,
     "bnb": 2.7039832197417555,
     "usdc": 1.452432345100643,
     "doge": 1.3385466574862281,
     "ada": 0.9228693172194044,
     "steth": 0.8230945225638056
 },
 "market_cap_change_percentage_24h_usd": -2.47022930527012,
 "updated_at": 1738144444
}
}
 
*/

// MARK: - Welcome
struct GlobalData: Codable {
    let data: MarketDataModel?
}

// MARK: - DataClass
struct MarketDataModel: Codable {
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double

    enum CodingKeys: String, CodingKey {
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }
    
    var marketCap: String{
        if let item = totalMarketCap.first(where: { (key, value) -> Bool in
            return key == "usd"
        }){
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var volume: String{
        if let item = totalVolume.first(where: {$0.key == "usd"}){ // THIS IS JUST A SHORTER WAY TO SWRITE WHAT WE HAVE WRITTEN ABOVE
            return  "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var btcDominance: String{
        if let item  = marketCapPercentage.first(where: {$0.key == "btc"}){
            return item.value.asPrecentString()
        }
        return ""
    }
}
 
