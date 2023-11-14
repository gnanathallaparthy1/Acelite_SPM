// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

/// The possible battery type values.
public enum BatteryType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case lithium
  case niMh
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "LITHIUM": self = .lithium
      case "NI_MH": self = .niMh
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .lithium: return "LITHIUM"
      case .niMh: return "NI_MH"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: BatteryType, rhs: BatteryType) -> Bool {
    switch (lhs, rhs) {
      case (.lithium, .lithium): return true
      case (.niMh, .niMh): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [BatteryType] {
    return [
      .lithium,
      .niMh,
    ]
  }
}

public enum ELM327ProtocolPreset: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case _1
  case _2
  case _3
  case _4
  case _5
  case _6
  case _7
  case _8
  case _9
  case _a
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "_1": self = ._1
      case "_2": self = ._2
      case "_3": self = ._3
      case "_4": self = ._4
      case "_5": self = ._5
      case "_6": self = ._6
      case "_7": self = ._7
      case "_8": self = ._8
      case "_9": self = ._9
      case "_A": self = ._a
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case ._1: return "_1"
      case ._2: return "_2"
      case ._3: return "_3"
      case ._4: return "_4"
      case ._5: return "_5"
      case ._6: return "_6"
      case ._7: return "_7"
      case ._8: return "_8"
      case ._9: return "_9"
      case ._a: return "_A"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: ELM327ProtocolPreset, rhs: ELM327ProtocolPreset) -> Bool {
    switch (lhs, rhs) {
      case (._1, ._1): return true
      case (._2, ._2): return true
      case (._3, ._3): return true
      case (._4, ._4): return true
      case (._5, ._5): return true
      case (._6, ._6): return true
      case (._7, ._7): return true
      case (._8, ._8): return true
      case (._9, ._9): return true
      case (._a, ._a): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [ELM327ProtocolPreset] {
    return [
      ._1,
      ._2,
      ._3,
      ._4,
      ._5,
      ._6,
      ._7,
      ._8,
      ._9,
      ._a,
    ]
  }
}

public enum OBDLinkProtocolPreset: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case _11
  case _12
  case _21
  case _22
  case _23
  case _24
  case _25
  case _31
  case _32
  case _33
  case _34
  case _35
  case _36
  case _41
  case _42
  case _51
  case _52
  case _53
  case _54
  case _61
  case _62
  case _63
  case _64
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "_11": self = ._11
      case "_12": self = ._12
      case "_21": self = ._21
      case "_22": self = ._22
      case "_23": self = ._23
      case "_24": self = ._24
      case "_25": self = ._25
      case "_31": self = ._31
      case "_32": self = ._32
      case "_33": self = ._33
      case "_34": self = ._34
      case "_35": self = ._35
      case "_36": self = ._36
      case "_41": self = ._41
      case "_42": self = ._42
      case "_51": self = ._51
      case "_52": self = ._52
      case "_53": self = ._53
      case "_54": self = ._54
      case "_61": self = ._61
      case "_62": self = ._62
      case "_63": self = ._63
      case "_64": self = ._64
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case ._11: return "_11"
      case ._12: return "_12"
      case ._21: return "_21"
      case ._22: return "_22"
      case ._23: return "_23"
      case ._24: return "_24"
      case ._25: return "_25"
      case ._31: return "_31"
      case ._32: return "_32"
      case ._33: return "_33"
      case ._34: return "_34"
      case ._35: return "_35"
      case ._36: return "_36"
      case ._41: return "_41"
      case ._42: return "_42"
      case ._51: return "_51"
      case ._52: return "_52"
      case ._53: return "_53"
      case ._54: return "_54"
      case ._61: return "_61"
      case ._62: return "_62"
      case ._63: return "_63"
      case ._64: return "_64"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: OBDLinkProtocolPreset, rhs: OBDLinkProtocolPreset) -> Bool {
    switch (lhs, rhs) {
      case (._11, ._11): return true
      case (._12, ._12): return true
      case (._21, ._21): return true
      case (._22, ._22): return true
      case (._23, ._23): return true
      case (._24, ._24): return true
      case (._25, ._25): return true
      case (._31, ._31): return true
      case (._32, ._32): return true
      case (._33, ._33): return true
      case (._34, ._34): return true
      case (._35, ._35): return true
      case (._36, ._36): return true
      case (._41, ._41): return true
      case (._42, ._42): return true
      case (._51, ._51): return true
      case (._52, ._52): return true
      case (._53, ._53): return true
      case (._54, ._54): return true
      case (._61, ._61): return true
      case (._62, ._62): return true
      case (._63, ._63): return true
      case (._64, ._64): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [OBDLinkProtocolPreset] {
    return [
      ._11,
      ._12,
      ._21,
      ._22,
      ._23,
      ._24,
      ._25,
      ._31,
      ._32,
      ._33,
      ._34,
      ._35,
      ._36,
      ._41,
      ._42,
      ._51,
      ._52,
      ._53,
      ._54,
      ._61,
      ._62,
      ._63,
      ._64,
    ]
  }
}

public struct SubmitBatteryDataFilesVehicleInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - vin: The given vehicle's VIN.
  ///   - make: The given vehicle's make.
  ///   - model: The given vehicle's model.
  ///   - year: The given vehicle's year.
  ///   - trim: A particular version of a model with a particular set of configuration.
  public init(vin: String, make: String, model: String, year: Int, trim: Swift.Optional<String?> = nil) {
    graphQLMap = ["vin": vin, "make": make, "model": model, "year": year, "trim": trim]
  }

  /// The given vehicle's VIN.
  public var vin: String {
    get {
      return graphQLMap["vin"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "vin")
    }
  }

  /// The given vehicle's make.
  public var make: String {
    get {
      return graphQLMap["make"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "make")
    }
  }

  /// The given vehicle's model.
  public var model: String {
    get {
      return graphQLMap["model"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "model")
    }
  }

  /// The given vehicle's year.
  public var year: Int {
    get {
      return graphQLMap["year"] as! Int
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "year")
    }
  }

  /// A particular version of a model with a particular set of configuration.
  public var trim: Swift.Optional<String?> {
    get {
      return graphQLMap["trim"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "trim")
    }
  }
}

public struct CalculateBatteryHealthInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - vehicleProfile: Vehicle's profile information
  ///   - obd2Test: Input for direct current internal resistance (also known as Alfred), gathered by issuing OBD2 commands.
  ///   - dashData: Input for data collected from the vehicle's dash, infotainment system, phone app, etc.
  ///   - locationCode: The vehicle's Manheim Location Code, matching one of the LocationCode enum values.
  ///   - workOrderNumber: The work order number associated with this battery data submission.
  ///   - totalNumberOfCharges: The total number of L1 + L2 + Fast charges
  ///   - lifetimeCharge: The total amount of electric charge that the battery has received over its lifespan, measured in Ah.
  ///   - lifetimeDischarge: The total amount of electric charge that the battery has discharged over its lifespan, measured in Ah.
  public init(vehicleProfile: Swift.Optional<CalculateBatteryHealthVehicleProfileInput?> = nil, obd2Test: Swift.Optional<OBD2TestInput?> = nil, dashData: Swift.Optional<DashDataInput?> = nil, locationCode: Swift.Optional<LocationCode?> = nil, workOrderNumber: Swift.Optional<String?> = nil, totalNumberOfCharges: Swift.Optional<Int?> = nil, lifetimeCharge: Swift.Optional<Double?> = nil, lifetimeDischarge: Swift.Optional<Double?> = nil) {
    graphQLMap = ["vehicleProfile": vehicleProfile, "obd2Test": obd2Test, "dashData": dashData, "locationCode": locationCode, "workOrderNumber": workOrderNumber, "totalNumberOfCharges": totalNumberOfCharges, "lifetimeCharge": lifetimeCharge, "lifetimeDischarge": lifetimeDischarge]
  }

  /// Vehicle's profile information
  public var vehicleProfile: Swift.Optional<CalculateBatteryHealthVehicleProfileInput?> {
    get {
      return graphQLMap["vehicleProfile"] as? Swift.Optional<CalculateBatteryHealthVehicleProfileInput?> ?? Swift.Optional<CalculateBatteryHealthVehicleProfileInput?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "vehicleProfile")
    }
  }

  /// Input for direct current internal resistance (also known as Alfred), gathered by issuing OBD2 commands.
  public var obd2Test: Swift.Optional<OBD2TestInput?> {
    get {
      return graphQLMap["obd2Test"] as? Swift.Optional<OBD2TestInput?> ?? Swift.Optional<OBD2TestInput?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "obd2Test")
    }
  }

  /// Input for data collected from the vehicle's dash, infotainment system, phone app, etc.
  public var dashData: Swift.Optional<DashDataInput?> {
    get {
      return graphQLMap["dashData"] as? Swift.Optional<DashDataInput?> ?? Swift.Optional<DashDataInput?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "dashData")
    }
  }

  /// The vehicle's Manheim Location Code, matching one of the LocationCode enum values.
  public var locationCode: Swift.Optional<LocationCode?> {
    get {
      return graphQLMap["locationCode"] as? Swift.Optional<LocationCode?> ?? Swift.Optional<LocationCode?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "locationCode")
    }
  }

  /// The work order number associated with this battery data submission.
  public var workOrderNumber: Swift.Optional<String?> {
    get {
      return graphQLMap["workOrderNumber"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "workOrderNumber")
    }
  }

  /// The total number of L1 + L2 + Fast charges
  public var totalNumberOfCharges: Swift.Optional<Int?> {
    get {
      return graphQLMap["totalNumberOfCharges"] as? Swift.Optional<Int?> ?? Swift.Optional<Int?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "totalNumberOfCharges")
    }
  }

  /// The total amount of electric charge that the battery has received over its lifespan, measured in Ah.
  public var lifetimeCharge: Swift.Optional<Double?> {
    get {
      return graphQLMap["lifetimeCharge"] as? Swift.Optional<Double?> ?? Swift.Optional<Double?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lifetimeCharge")
    }
  }

  /// The total amount of electric charge that the battery has discharged over its lifespan, measured in Ah.
  public var lifetimeDischarge: Swift.Optional<Double?> {
    get {
      return graphQLMap["lifetimeDischarge"] as? Swift.Optional<Double?> ?? Swift.Optional<Double?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lifetimeDischarge")
    }
  }
}

public struct CalculateBatteryHealthVehicleProfileInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - nominalVoltage: The rated voltage at which the battery is designed to operate, measured in volts.
  ///   - energyAtBirth: The total amount of energy the battery can store when when fully charged at the time of its production, measured in kWh.
  ///   - batteryType: The battery's current type, matching one of the BatteryType enum values.
  ///   - capacityAtBirth: The maximum amount of electric charge the battery can hold when fully charged at the time of its production, measured in Ah.
  ///   - rangeAtBirth: The battery's range when brand new, in miles.
  ///   - designChargeCycles: The number of charge-discharge cycles that the battery is designed to endure throughout its lifespan.
  public init(nominalVoltage: Swift.Optional<Double?> = nil, energyAtBirth: Swift.Optional<Double?> = nil, batteryType: Swift.Optional<BatteryType?> = nil, capacityAtBirth: Swift.Optional<Double?> = nil, rangeAtBirth: Swift.Optional<Double?> = nil, designChargeCycles: Swift.Optional<Double?> = nil) {
    graphQLMap = ["nominalVoltage": nominalVoltage, "energyAtBirth": energyAtBirth, "batteryType": batteryType, "capacityAtBirth": capacityAtBirth, "rangeAtBirth": rangeAtBirth, "designChargeCycles": designChargeCycles]
  }

  /// The rated voltage at which the battery is designed to operate, measured in volts.
  public var nominalVoltage: Swift.Optional<Double?> {
    get {
      return graphQLMap["nominalVoltage"] as? Swift.Optional<Double?> ?? Swift.Optional<Double?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "nominalVoltage")
    }
  }

  /// The total amount of energy the battery can store when when fully charged at the time of its production, measured in kWh.
  public var energyAtBirth: Swift.Optional<Double?> {
    get {
      return graphQLMap["energyAtBirth"] as? Swift.Optional<Double?> ?? Swift.Optional<Double?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "energyAtBirth")
    }
  }

  /// The battery's current type, matching one of the BatteryType enum values.
  public var batteryType: Swift.Optional<BatteryType?> {
    get {
      return graphQLMap["batteryType"] as? Swift.Optional<BatteryType?> ?? Swift.Optional<BatteryType?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "batteryType")
    }
  }

  /// The maximum amount of electric charge the battery can hold when fully charged at the time of its production, measured in Ah.
  public var capacityAtBirth: Swift.Optional<Double?> {
    get {
      return graphQLMap["capacityAtBirth"] as? Swift.Optional<Double?> ?? Swift.Optional<Double?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "capacityAtBirth")
    }
  }

  /// The battery's range when brand new, in miles.
  public var rangeAtBirth: Swift.Optional<Double?> {
    get {
      return graphQLMap["rangeAtBirth"] as? Swift.Optional<Double?> ?? Swift.Optional<Double?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "rangeAtBirth")
    }
  }

  /// The number of charge-discharge cycles that the battery is designed to endure throughout its lifespan.
  public var designChargeCycles: Swift.Optional<Double?> {
    get {
      return graphQLMap["designChargeCycles"] as? Swift.Optional<Double?> ?? Swift.Optional<Double?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "designChargeCycles")
    }
  }
}

/// Input for DCIR (direct current internal resistance), also referred to as Alfred. This input type will primarily be
/// used by Mobility in conjunction with the Battery Interrogation service. Data is primarily gathered by issuing OBD2
/// commands to a vehicle's BMS (Battery Management System).
public struct OBD2TestInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - filename: The file name of the pack-voltage, pack-current, or cell-voltages JSON file uploaded by the user, which
  /// contains the list of voltages collected from the battery pack in volts, the list of currents
  /// collected from the battery pack in amps, or the list of cell voltages for each cell in the battery.
  ///   - transactionId: The unique id used to identify the uploaded files in S3
  ///   - instructionSetId: Challenge Instruction Set Id
  ///   - odometer: The vehicle's current odometer reading, in miles.
  ///   - currentEnergy: Current energy of battery in kWh at the current state of charge. If provided, this will be used along with
  /// stateOfCharge to calculate estimated range.
  ///   - stateOfCharge: The current state of charge, between 0 and 100. If provided, this will be used along with currentEnergy to
  /// calculate estimated range.
  ///   - bmsCapacity: The current BMS capacity in Ah. This will be used to calculate estimated range if stateOfCharge and
  /// currentEnergy are not provided.
  public init(filename: Swift.Optional<String?> = nil, transactionId: Swift.Optional<String?> = nil, instructionSetId: Swift.Optional<String?> = nil, odometer: Swift.Optional<Int?> = nil, currentEnergy: Swift.Optional<Double?> = nil, stateOfCharge: Swift.Optional<Double?> = nil, bmsCapacity: Swift.Optional<Double?> = nil) {
    graphQLMap = ["filename": filename, "transactionId": transactionId, "instructionSetId": instructionSetId, "odometer": odometer, "currentEnergy": currentEnergy, "stateOfCharge": stateOfCharge, "bmsCapacity": bmsCapacity]
  }

  /// The file name of the pack-voltage, pack-current, or cell-voltages JSON file uploaded by the user, which
  /// contains the list of voltages collected from the battery pack in volts, the list of currents
  /// collected from the battery pack in amps, or the list of cell voltages for each cell in the battery.
  public var filename: Swift.Optional<String?> {
    get {
      return graphQLMap["filename"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "filename")
    }
  }

  /// The unique id used to identify the uploaded files in S3
  public var transactionId: Swift.Optional<String?> {
    get {
      return graphQLMap["transactionId"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "transactionId")
    }
  }

  /// Challenge Instruction Set Id
  public var instructionSetId: Swift.Optional<String?> {
    get {
      return graphQLMap["instructionSetId"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "instructionSetId")
    }
  }

  /// The vehicle's current odometer reading, in miles.
  public var odometer: Swift.Optional<Int?> {
    get {
      return graphQLMap["odometer"] as? Swift.Optional<Int?> ?? Swift.Optional<Int?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "odometer")
    }
  }

  /// Current energy of battery in kWh at the current state of charge. If provided, this will be used along with
  /// stateOfCharge to calculate estimated range.
  public var currentEnergy: Swift.Optional<Double?> {
    get {
      return graphQLMap["currentEnergy"] as? Swift.Optional<Double?> ?? Swift.Optional<Double?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "currentEnergy")
    }
  }

  /// The current state of charge, between 0 and 100. If provided, this will be used along with currentEnergy to
  /// calculate estimated range.
  public var stateOfCharge: Swift.Optional<Double?> {
    get {
      return graphQLMap["stateOfCharge"] as? Swift.Optional<Double?> ?? Swift.Optional<Double?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "stateOfCharge")
    }
  }

  /// The current BMS capacity in Ah. This will be used to calculate estimated range if stateOfCharge and
  /// currentEnergy are not provided.
  public var bmsCapacity: Swift.Optional<Double?> {
    get {
      return graphQLMap["bmsCapacity"] as? Swift.Optional<Double?> ?? Swift.Optional<Double?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "bmsCapacity")
    }
  }
}

/// Data collected vehicle's Dash, Infotainment System, phone app, etc. which is not explicitly pulled from a vehicle's BMS.
/// The accuracy of this data is not trusted implicitly.
public struct DashDataInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - odometer: The vehicle's current odometer reading, in miles.
  ///   - remainingMileage: The remaining mileage on the given state of charge.
  ///   - stateOfCharge: The current state of charge, between 0 and 100
  public init(odometer: Swift.Optional<Int?> = nil, remainingMileage: Swift.Optional<Double?> = nil, stateOfCharge: Swift.Optional<Double?> = nil) {
    graphQLMap = ["odometer": odometer, "remainingMileage": remainingMileage, "stateOfCharge": stateOfCharge]
  }

  /// The vehicle's current odometer reading, in miles.
  public var odometer: Swift.Optional<Int?> {
    get {
      return graphQLMap["odometer"] as? Swift.Optional<Int?> ?? Swift.Optional<Int?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "odometer")
    }
  }

  /// The remaining mileage on the given state of charge.
  public var remainingMileage: Swift.Optional<Double?> {
    get {
      return graphQLMap["remainingMileage"] as? Swift.Optional<Double?> ?? Swift.Optional<Double?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "remainingMileage")
    }
  }

  /// The current state of charge, between 0 and 100
  public var stateOfCharge: Swift.Optional<Double?> {
    get {
      return graphQLMap["stateOfCharge"] as? Swift.Optional<Double?> ?? Swift.Optional<Double?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "stateOfCharge")
    }
  }
}

/// The possible Manheim Location Code values.
public enum LocationCode: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case aaa
  case aaai
  case aaaw
  case alba
  case aloh
  case aren
  case ayca
  case baa
  case bcaa
  case bigh
  case bwae
  case caai
  case cade
  case cina
  case clev
  case daa
  case daae
  case dade
  case dala
  case deta
  case dfwa
  case faa
  case faao
  case fada
  case gcaa
  case goaa
  case haa
  case hata
  case indy
  case jax
  case kcaa
  case keya
  case laa
  case lmaa
  case loua
  case lphx
  case maa
  case maai
  case miss
  case mlra
  case mmaa
  case naa
  case nade
  case nash
  case noaa
  case nsaa
  case nvaa
  case nwe
  case oaa
  case omaa
  case paa
  case pcaa
  case praa
  case ptaf
  case pxaa
  case raa
  case rsaa
  case saaa
  case sapl
  case sapt
  case scaa
  case sdaa
  case skya
  case slaa
  case sonb
  case spaa
  case ssaa
  case svaa
  case swfl
  case tbaa
  case tcaa
  case thaa
  case uaa
  case wpba
  case wstx
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "AAA": self = .aaa
      case "AAAI": self = .aaai
      case "AAAW": self = .aaaw
      case "ALBA": self = .alba
      case "ALOH": self = .aloh
      case "AREN": self = .aren
      case "AYCA": self = .ayca
      case "BAA": self = .baa
      case "BCAA": self = .bcaa
      case "BIGH": self = .bigh
      case "BWAE": self = .bwae
      case "CAAI": self = .caai
      case "CADE": self = .cade
      case "CINA": self = .cina
      case "CLEV": self = .clev
      case "DAA": self = .daa
      case "DAAE": self = .daae
      case "DADE": self = .dade
      case "DALA": self = .dala
      case "DETA": self = .deta
      case "DFWA": self = .dfwa
      case "FAA": self = .faa
      case "FAAO": self = .faao
      case "FADA": self = .fada
      case "GCAA": self = .gcaa
      case "GOAA": self = .goaa
      case "HAA": self = .haa
      case "HATA": self = .hata
      case "INDY": self = .indy
      case "JAX": self = .jax
      case "KCAA": self = .kcaa
      case "KEYA": self = .keya
      case "LAA": self = .laa
      case "LMAA": self = .lmaa
      case "LOUA": self = .loua
      case "LPHX": self = .lphx
      case "MAA": self = .maa
      case "MAAI": self = .maai
      case "MISS": self = .miss
      case "MLRA": self = .mlra
      case "MMAA": self = .mmaa
      case "NAA": self = .naa
      case "NADE": self = .nade
      case "NASH": self = .nash
      case "NOAA": self = .noaa
      case "NSAA": self = .nsaa
      case "NVAA": self = .nvaa
      case "NWE": self = .nwe
      case "OAA": self = .oaa
      case "OMAA": self = .omaa
      case "PAA": self = .paa
      case "PCAA": self = .pcaa
      case "PRAA": self = .praa
      case "PTAF": self = .ptaf
      case "PXAA": self = .pxaa
      case "RAA": self = .raa
      case "RSAA": self = .rsaa
      case "SAAA": self = .saaa
      case "SAPL": self = .sapl
      case "SAPT": self = .sapt
      case "SCAA": self = .scaa
      case "SDAA": self = .sdaa
      case "SKYA": self = .skya
      case "SLAA": self = .slaa
      case "SONB": self = .sonb
      case "SPAA": self = .spaa
      case "SSAA": self = .ssaa
      case "SVAA": self = .svaa
      case "SWFL": self = .swfl
      case "TBAA": self = .tbaa
      case "TCAA": self = .tcaa
      case "THAA": self = .thaa
      case "UAA": self = .uaa
      case "WPBA": self = .wpba
      case "WSTX": self = .wstx
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .aaa: return "AAA"
      case .aaai: return "AAAI"
      case .aaaw: return "AAAW"
      case .alba: return "ALBA"
      case .aloh: return "ALOH"
      case .aren: return "AREN"
      case .ayca: return "AYCA"
      case .baa: return "BAA"
      case .bcaa: return "BCAA"
      case .bigh: return "BIGH"
      case .bwae: return "BWAE"
      case .caai: return "CAAI"
      case .cade: return "CADE"
      case .cina: return "CINA"
      case .clev: return "CLEV"
      case .daa: return "DAA"
      case .daae: return "DAAE"
      case .dade: return "DADE"
      case .dala: return "DALA"
      case .deta: return "DETA"
      case .dfwa: return "DFWA"
      case .faa: return "FAA"
      case .faao: return "FAAO"
      case .fada: return "FADA"
      case .gcaa: return "GCAA"
      case .goaa: return "GOAA"
      case .haa: return "HAA"
      case .hata: return "HATA"
      case .indy: return "INDY"
      case .jax: return "JAX"
      case .kcaa: return "KCAA"
      case .keya: return "KEYA"
      case .laa: return "LAA"
      case .lmaa: return "LMAA"
      case .loua: return "LOUA"
      case .lphx: return "LPHX"
      case .maa: return "MAA"
      case .maai: return "MAAI"
      case .miss: return "MISS"
      case .mlra: return "MLRA"
      case .mmaa: return "MMAA"
      case .naa: return "NAA"
      case .nade: return "NADE"
      case .nash: return "NASH"
      case .noaa: return "NOAA"
      case .nsaa: return "NSAA"
      case .nvaa: return "NVAA"
      case .nwe: return "NWE"
      case .oaa: return "OAA"
      case .omaa: return "OMAA"
      case .paa: return "PAA"
      case .pcaa: return "PCAA"
      case .praa: return "PRAA"
      case .ptaf: return "PTAF"
      case .pxaa: return "PXAA"
      case .raa: return "RAA"
      case .rsaa: return "RSAA"
      case .saaa: return "SAAA"
      case .sapl: return "SAPL"
      case .sapt: return "SAPT"
      case .scaa: return "SCAA"
      case .sdaa: return "SDAA"
      case .skya: return "SKYA"
      case .slaa: return "SLAA"
      case .sonb: return "SONB"
      case .spaa: return "SPAA"
      case .ssaa: return "SSAA"
      case .svaa: return "SVAA"
      case .swfl: return "SWFL"
      case .tbaa: return "TBAA"
      case .tcaa: return "TCAA"
      case .thaa: return "THAA"
      case .uaa: return "UAA"
      case .wpba: return "WPBA"
      case .wstx: return "WSTX"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: LocationCode, rhs: LocationCode) -> Bool {
    switch (lhs, rhs) {
      case (.aaa, .aaa): return true
      case (.aaai, .aaai): return true
      case (.aaaw, .aaaw): return true
      case (.alba, .alba): return true
      case (.aloh, .aloh): return true
      case (.aren, .aren): return true
      case (.ayca, .ayca): return true
      case (.baa, .baa): return true
      case (.bcaa, .bcaa): return true
      case (.bigh, .bigh): return true
      case (.bwae, .bwae): return true
      case (.caai, .caai): return true
      case (.cade, .cade): return true
      case (.cina, .cina): return true
      case (.clev, .clev): return true
      case (.daa, .daa): return true
      case (.daae, .daae): return true
      case (.dade, .dade): return true
      case (.dala, .dala): return true
      case (.deta, .deta): return true
      case (.dfwa, .dfwa): return true
      case (.faa, .faa): return true
      case (.faao, .faao): return true
      case (.fada, .fada): return true
      case (.gcaa, .gcaa): return true
      case (.goaa, .goaa): return true
      case (.haa, .haa): return true
      case (.hata, .hata): return true
      case (.indy, .indy): return true
      case (.jax, .jax): return true
      case (.kcaa, .kcaa): return true
      case (.keya, .keya): return true
      case (.laa, .laa): return true
      case (.lmaa, .lmaa): return true
      case (.loua, .loua): return true
      case (.lphx, .lphx): return true
      case (.maa, .maa): return true
      case (.maai, .maai): return true
      case (.miss, .miss): return true
      case (.mlra, .mlra): return true
      case (.mmaa, .mmaa): return true
      case (.naa, .naa): return true
      case (.nade, .nade): return true
      case (.nash, .nash): return true
      case (.noaa, .noaa): return true
      case (.nsaa, .nsaa): return true
      case (.nvaa, .nvaa): return true
      case (.nwe, .nwe): return true
      case (.oaa, .oaa): return true
      case (.omaa, .omaa): return true
      case (.paa, .paa): return true
      case (.pcaa, .pcaa): return true
      case (.praa, .praa): return true
      case (.ptaf, .ptaf): return true
      case (.pxaa, .pxaa): return true
      case (.raa, .raa): return true
      case (.rsaa, .rsaa): return true
      case (.saaa, .saaa): return true
      case (.sapl, .sapl): return true
      case (.sapt, .sapt): return true
      case (.scaa, .scaa): return true
      case (.sdaa, .sdaa): return true
      case (.skya, .skya): return true
      case (.slaa, .slaa): return true
      case (.sonb, .sonb): return true
      case (.spaa, .spaa): return true
      case (.ssaa, .ssaa): return true
      case (.svaa, .svaa): return true
      case (.swfl, .swfl): return true
      case (.tbaa, .tbaa): return true
      case (.tcaa, .tcaa): return true
      case (.thaa, .thaa): return true
      case (.uaa, .uaa): return true
      case (.wpba, .wpba): return true
      case (.wstx, .wstx): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [LocationCode] {
    return [
      .aaa,
      .aaai,
      .aaaw,
      .alba,
      .aloh,
      .aren,
      .ayca,
      .baa,
      .bcaa,
      .bigh,
      .bwae,
      .caai,
      .cade,
      .cina,
      .clev,
      .daa,
      .daae,
      .dade,
      .dala,
      .deta,
      .dfwa,
      .faa,
      .faao,
      .fada,
      .gcaa,
      .goaa,
      .haa,
      .hata,
      .indy,
      .jax,
      .kcaa,
      .keya,
      .laa,
      .lmaa,
      .loua,
      .lphx,
      .maa,
      .maai,
      .miss,
      .mlra,
      .mmaa,
      .naa,
      .nade,
      .nash,
      .noaa,
      .nsaa,
      .nvaa,
      .nwe,
      .oaa,
      .omaa,
      .paa,
      .pcaa,
      .praa,
      .ptaf,
      .pxaa,
      .raa,
      .rsaa,
      .saaa,
      .sapl,
      .sapt,
      .scaa,
      .sdaa,
      .skya,
      .slaa,
      .sonb,
      .spaa,
      .ssaa,
      .svaa,
      .swfl,
      .tbaa,
      .tcaa,
      .thaa,
      .uaa,
      .wpba,
      .wstx,
    ]
  }
}

/// The possible battery score grade values.
public enum Grade: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case a
  case b
  case c
  case d
  case f
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "A": self = .a
      case "B": self = .b
      case "C": self = .c
      case "D": self = .d
      case "F": self = .f
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .a: return "A"
      case .b: return "B"
      case .c: return "C"
      case .d: return "D"
      case .f: return "F"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: Grade, rhs: Grade) -> Bool {
    switch (lhs, rhs) {
      case (.a, .a): return true
      case (.b, .b): return true
      case (.c, .c): return true
      case (.d, .d): return true
      case (.f, .f): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [Grade] {
    return [
      .a,
      .b,
      .c,
      .d,
      .f,
    ]
  }
}

/// The possible battery score health values.
public enum Health: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case poor
  case fair
  case good
  case great
  case excellent
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "Poor": self = .poor
      case "Fair": self = .fair
      case "Good": self = .good
      case "Great": self = .great
      case "Excellent": self = .excellent
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .poor: return "Poor"
      case .fair: return "Fair"
      case .good: return "Good"
      case .great: return "Great"
      case .excellent: return "Excellent"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: Health, rhs: Health) -> Bool {
    switch (lhs, rhs) {
      case (.poor, .poor): return true
      case (.fair, .fair): return true
      case (.good, .good): return true
      case (.great, .great): return true
      case (.excellent, .excellent): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [Health] {
    return [
      .poor,
      .fair,
      .good,
      .great,
      .excellent,
    ]
  }
}

/// The possible factor type source values.
public enum TypeSource: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case `default`
  case ingestion
  case ymm
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "default": self = .default
      case "ingestion": self = .ingestion
      case "ymm": self = .ymm
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .default: return "default"
      case .ingestion: return "ingestion"
      case .ymm: return "ymm"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: TypeSource, rhs: TypeSource) -> Bool {
    switch (lhs, rhs) {
      case (.default, .default): return true
      case (.ingestion, .ingestion): return true
      case (.ymm, .ymm): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [TypeSource] {
    return [
      .default,
      .ingestion,
      .ymm,
    ]
  }
}

public struct SubmitBatteryDataFilesPropsInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - locationCode: The vehicle's Manheim Location Code, matching one of the LocationCode enum values.
  ///   - odometer: The vehicle's current odometer reading, in miles.
  ///   - totalNumberOfCharges: The total number of L1 + L2 + Fast charges
  ///   - lifetimeCharge: ??
  ///   - lifetimeDischarge: ??
  ///   - packVoltageFilename: The actual file name of the pack-voltage csv file uploaded by the user which containing the list of voltages collected from the battery pack in volts
  ///   - packCurrentFilename: The actual file name of the pack-current csv file uploaded by the user which containing the list of currents collected from the battery pack in amps
  ///   - cellVoltagesFilename: The actual name of the cell-voltages csv file uploaded by the user which containing the list of cell voltages for each cell in the battery
  ///   - transactionId: The unique id used to identify the uploaded files in S3
  ///   - vehicleProfile: Vehicle's profile information
  ///   - instructionSetId: Challenge Instruction Set Id
  public init(locationCode: Swift.Optional<LocationCode?> = nil, odometer: Swift.Optional<Int?> = nil, totalNumberOfCharges: Swift.Optional<Int?> = nil, lifetimeCharge: Swift.Optional<Double?> = nil, lifetimeDischarge: Swift.Optional<Double?> = nil, packVoltageFilename: String, packCurrentFilename: String, cellVoltagesFilename: String, transactionId: String, vehicleProfile: SubmitBatteryDataVehicleProfileInput, instructionSetId: Swift.Optional<String?> = nil) {
    graphQLMap = ["locationCode": locationCode, "odometer": odometer, "totalNumberOfCharges": totalNumberOfCharges, "lifetimeCharge": lifetimeCharge, "lifetimeDischarge": lifetimeDischarge, "packVoltageFilename": packVoltageFilename, "packCurrentFilename": packCurrentFilename, "cellVoltagesFilename": cellVoltagesFilename, "transactionId": transactionId, "vehicleProfile": vehicleProfile, "instructionSetId": instructionSetId]
  }

  /// The vehicle's Manheim Location Code, matching one of the LocationCode enum values.
  public var locationCode: Swift.Optional<LocationCode?> {
    get {
      return graphQLMap["locationCode"] as? Swift.Optional<LocationCode?> ?? Swift.Optional<LocationCode?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "locationCode")
    }
  }

  /// The vehicle's current odometer reading, in miles.
  public var odometer: Swift.Optional<Int?> {
    get {
      return graphQLMap["odometer"] as? Swift.Optional<Int?> ?? Swift.Optional<Int?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "odometer")
    }
  }

  /// The total number of L1 + L2 + Fast charges
  public var totalNumberOfCharges: Swift.Optional<Int?> {
    get {
      return graphQLMap["totalNumberOfCharges"] as? Swift.Optional<Int?> ?? Swift.Optional<Int?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "totalNumberOfCharges")
    }
  }

  /// ??
  public var lifetimeCharge: Swift.Optional<Double?> {
    get {
      return graphQLMap["lifetimeCharge"] as? Swift.Optional<Double?> ?? Swift.Optional<Double?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lifetimeCharge")
    }
  }

  /// ??
  public var lifetimeDischarge: Swift.Optional<Double?> {
    get {
      return graphQLMap["lifetimeDischarge"] as? Swift.Optional<Double?> ?? Swift.Optional<Double?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lifetimeDischarge")
    }
  }

  /// The actual file name of the pack-voltage csv file uploaded by the user which containing the list of voltages collected from the battery pack in volts
  public var packVoltageFilename: String {
    get {
      return graphQLMap["packVoltageFilename"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "packVoltageFilename")
    }
  }

  /// The actual file name of the pack-current csv file uploaded by the user which containing the list of currents collected from the battery pack in amps
  public var packCurrentFilename: String {
    get {
      return graphQLMap["packCurrentFilename"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "packCurrentFilename")
    }
  }

  /// The actual name of the cell-voltages csv file uploaded by the user which containing the list of cell voltages for each cell in the battery
  public var cellVoltagesFilename: String {
    get {
      return graphQLMap["cellVoltagesFilename"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "cellVoltagesFilename")
    }
  }

  /// The unique id used to identify the uploaded files in S3
  public var transactionId: String {
    get {
      return graphQLMap["transactionId"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "transactionId")
    }
  }

  /// Vehicle's profile information
  public var vehicleProfile: SubmitBatteryDataVehicleProfileInput {
    get {
      return graphQLMap["vehicleProfile"] as! SubmitBatteryDataVehicleProfileInput
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "vehicleProfile")
    }
  }

  /// Challenge Instruction Set Id
  public var instructionSetId: Swift.Optional<String?> {
    get {
      return graphQLMap["instructionSetId"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "instructionSetId")
    }
  }
}

public struct SubmitBatteryDataVehicleProfileInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - nominalVoltage
  ///   - energyAtBirth
  ///   - batteryType
  ///   - capacityAtBirth
  ///   - rangeAtBirth
  ///   - designChargeCycles
  public init(nominalVoltage: Double, energyAtBirth: Double, batteryType: BatteryType, capacityAtBirth: Double, rangeAtBirth: Swift.Optional<Double?> = nil, designChargeCycles: Swift.Optional<Double?> = nil) {
    graphQLMap = ["nominalVoltage": nominalVoltage, "energyAtBirth": energyAtBirth, "batteryType": batteryType, "capacityAtBirth": capacityAtBirth, "rangeAtBirth": rangeAtBirth, "designChargeCycles": designChargeCycles]
  }

  public var nominalVoltage: Double {
    get {
      return graphQLMap["nominalVoltage"] as! Double
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "nominalVoltage")
    }
  }

  public var energyAtBirth: Double {
    get {
      return graphQLMap["energyAtBirth"] as! Double
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "energyAtBirth")
    }
  }

  public var batteryType: BatteryType {
    get {
      return graphQLMap["batteryType"] as! BatteryType
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "batteryType")
    }
  }

  public var capacityAtBirth: Double {
    get {
      return graphQLMap["capacityAtBirth"] as! Double
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "capacityAtBirth")
    }
  }

  public var rangeAtBirth: Swift.Optional<Double?> {
    get {
      return graphQLMap["rangeAtBirth"] as? Swift.Optional<Double?> ?? Swift.Optional<Double?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "rangeAtBirth")
    }
  }

  public var designChargeCycles: Swift.Optional<Double?> {
    get {
      return graphQLMap["designChargeCycles"] as? Swift.Optional<Double?> ?? Swift.Optional<Double?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "designChargeCycles")
    }
  }
}

public struct StateOfChargePropsInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - stateOfCharge: The current state of charge, between 0 and 100
  ///   - currentEnergy: Current energy of battery in kWh at the current state of charge
  public init(stateOfCharge: Double, currentEnergy: Double) {
    graphQLMap = ["stateOfCharge": stateOfCharge, "currentEnergy": currentEnergy]
  }

  /// The current state of charge, between 0 and 100
  public var stateOfCharge: Double {
    get {
      return graphQLMap["stateOfCharge"] as! Double
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "stateOfCharge")
    }
  }

  /// Current energy of battery in kWh at the current state of charge
  public var currentEnergy: Double {
    get {
      return graphQLMap["currentEnergy"] as! Double
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "currentEnergy")
    }
  }
}

public struct BMSCapacityPropsInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - bmsCapacity: The current BMS capacity in Ah
  public init(bmsCapacity: Double) {
    graphQLMap = ["bmsCapacity": bmsCapacity]
  }

  /// The current BMS capacity in Ah
  public var bmsCapacity: Double {
    get {
      return graphQLMap["bmsCapacity"] as! Double
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "bmsCapacity")
    }
  }
}

public final class VehicleInfoQueryQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query VehicleInfoQuery($vin: String) {
      vehicle(vin: $vin) {
        __typename
        make
        modelName
        year
        vin
        mid
        manufacturer
        bodyStyle
        bodyType
        trimName
        title
        year
        vehicleType
        getBatteryTestInstructions {
          __typename
          testCommands {
            __typename
            ... on ChallengeTestCommands {
              __typename
              id
              vehicleProfile {
                __typename
                nominalVoltage
                energyAtBirth
                batteryType
                capacityAtBirth
                rangeAtBirth
                designChargeCycles
              }
              odometer {
                __typename
                protocol {
                  __typename
                  elm327ProtocolPreset
                  obdLinkProtocolPreset
                }
                challenge {
                  __typename
                  canFilter
                  canMask
                  header
                  pid
                  flowControl {
                    __typename
                    flowControlHeader
                    flowControlData
                  }
                }
                response {
                  __typename
                  startByte
                  endByte
                  multiplier
                  constant
                }
                validation {
                  __typename
                  numberOfFrames
                  lowerBounds
                  upperBounds
                }
              }
              stateOfCharge {
                __typename
                protocol {
                  __typename
                  elm327ProtocolPreset
                  obdLinkProtocolPreset
                }
                validation {
                  __typename
                  upperBounds
                  lowerBounds
                  numberOfFrames
                }
                challenge {
                  __typename
                  canFilter
                  canMask
                  header
                  pid
                  flowControl {
                    __typename
                    flowControlHeader
                    flowControlData
                  }
                }
                response {
                  __typename
                  constant
                  multiplier
                  startByte
                  endByte
                }
              }
              energyToEmpty {
                __typename
                protocol {
                  __typename
                  elm327ProtocolPreset
                  obdLinkProtocolPreset
                }
                challenge {
                  __typename
                  canFilter
                  canMask
                  header
                  pid
                  flowControl {
                    __typename
                    flowControlHeader
                    flowControlData
                  }
                }
                response {
                  __typename
                  startByte
                  endByte
                  multiplier
                  constant
                }
                validation {
                  __typename
                  numberOfFrames
                  lowerBounds
                  upperBounds
                }
              }
              bmsCapacity {
                __typename
                challenge {
                  __typename
                  canFilter
                  canMask
                  header
                  pid
                  flowControl {
                    __typename
                    flowControlHeader
                    flowControlData
                  }
                }
                protocol {
                  __typename
                  elm327ProtocolPreset
                  obdLinkProtocolPreset
                }
                response {
                  __typename
                  constant
                  endByte
                  startByte
                  multiplier
                }
                validation {
                  __typename
                  lowerBounds
                  upperBounds
                  numberOfFrames
                }
              }
              sampledCommands {
                __typename
                protocol {
                  __typename
                  elm327ProtocolPreset
                  obdLinkProtocolPreset
                }
                packTemperature {
                  __typename
                  challenge {
                    __typename
                    canFilter
                    canMask
                    header
                    pid
                    flowControl {
                      __typename
                      flowControlHeader
                      flowControlData
                    }
                  }
                  response {
                    __typename
                    startByte
                    endByte
                    numberOfSensors
                    bytesPerSensors
                    startSensorsCount
                    endSensorsCount
                    bytesPaddedBetweenSensors
                    multiplier
                    constant
                  }
                  validation {
                    __typename
                    numberOfFrames
                    lowerBounds
                    upperBounds
                  }
                }
                packVoltage {
                  __typename
                  challenge {
                    __typename
                    canFilter
                    canMask
                    header
                    pid
                    flowControl {
                      __typename
                      flowControlHeader
                      flowControlData
                    }
                  }
                  response {
                    __typename
                    startByte
                    endByte
                    multiplier
                    constant
                  }
                  validation {
                    __typename
                    upperBounds
                    lowerBounds
                    numberOfFrames
                  }
                }
                packCurrent {
                  __typename
                  challenge {
                    __typename
                    canFilter
                    canMask
                    header
                    pid
                    flowControl {
                      __typename
                      flowControlHeader
                      flowControlData
                    }
                  }
                  response {
                    __typename
                    startByte
                    endByte
                    multiplier
                    constant
                  }
                  validation {
                    __typename
                    numberOfFrames
                    lowerBounds
                    upperBounds
                  }
                }
                cellVoltage {
                  __typename
                  challenge {
                    __typename
                    canFilter
                    canMask
                    header
                    pid
                    flowControl {
                      __typename
                      flowControlHeader
                      flowControlData
                    }
                  }
                  response {
                    __typename
                    startByte
                    endByte
                    numberOfCells
                    bytesPerCell
                    startCellCount
                    endCellCount
                    bytesPaddedBetweenCells
                    multiplier
                    constant
                  }
                  validation {
                    __typename
                    lowerBounds
                    upperBounds
                    numberOfFrames
                  }
                }
              }
              batteryAge {
                __typename
                protocol {
                  __typename
                  elm327ProtocolPreset
                  obdLinkProtocolPreset
                }
                challenge {
                  __typename
                  canFilter
                  canMask
                  header
                  pid
                  flowControl {
                    __typename
                    flowControlHeader
                    flowControlData
                  }
                }
                response {
                  __typename
                  startByte
                  endByte
                  multiplier
                  constant
                }
                validation {
                  __typename
                  numberOfFrames
                  lowerBounds
                  upperBounds
                }
              }
              diagnosticSession {
                __typename
                protocol {
                  __typename
                  elm327ProtocolPreset
                  obdLinkProtocolPreset
                }
                challenge {
                  __typename
                  canFilter
                  canMask
                  header
                  pid
                }
              }
              miscCommands {
                __typename
                label
                instruction {
                  __typename
                  challenge {
                    __typename
                    canFilter
                    canMask
                    header
                    pid
                    flowControl {
                      __typename
                      flowControlHeader
                      flowControlData
                    }
                  }
                  protocol {
                    __typename
                    elm327ProtocolPreset
                    obdLinkProtocolPreset
                  }
                  response {
                    __typename
                    constant
                    endByte
                    multiplier
                    startByte
                  }
                  validation {
                    __typename
                    numberOfFrames
                    upperBounds
                    lowerBounds
                  }
                }
              }
            }
          }
        }
      }
    }
    """

  public let operationName: String = "VehicleInfoQuery"

  public var vin: String?

  public init(vin: String? = nil) {
    self.vin = vin
  }

  public var variables: GraphQLMap? {
    return ["vin": vin]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("vehicle", arguments: ["vin": GraphQLVariable("vin")], type: .object(Vehicle.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(vehicle: Vehicle? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "vehicle": vehicle.flatMap { (value: Vehicle) -> ResultMap in value.resultMap }])
    }

    /// Retrieve attributes for a given vehicle using the Catalog API or the NHTSA API by passing one of following:
    /// VIN, MID, Catalog ID, or Chrome Style ID. For fields retrieved from the NHTSA API, VIN is the only valid input.
    public var vehicle: Vehicle? {
      get {
        return (resultMap["vehicle"] as? ResultMap).flatMap { Vehicle(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "vehicle")
      }
    }

    public struct Vehicle: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Vehicle"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("make", type: .scalar(String.self)),
          GraphQLField("modelName", type: .scalar(String.self)),
          GraphQLField("year", type: .scalar(Int.self)),
          GraphQLField("vin", type: .scalar(String.self)),
          GraphQLField("mid", type: .scalar(String.self)),
          GraphQLField("manufacturer", type: .scalar(String.self)),
          GraphQLField("bodyStyle", type: .scalar(String.self)),
          GraphQLField("bodyType", type: .scalar(String.self)),
          GraphQLField("trimName", type: .scalar(String.self)),
          GraphQLField("title", type: .scalar(String.self)),
          GraphQLField("year", type: .scalar(Int.self)),
          GraphQLField("vehicleType", type: .scalar(String.self)),
          GraphQLField("getBatteryTestInstructions", type: .list(.nonNull(.object(GetBatteryTestInstruction.selections)))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(make: String? = nil, modelName: String? = nil, year: Int? = nil, vin: String? = nil, mid: String? = nil, manufacturer: String? = nil, bodyStyle: String? = nil, bodyType: String? = nil, trimName: String? = nil, title: String? = nil, vehicleType: String? = nil, getBatteryTestInstructions: [GetBatteryTestInstruction]? = nil) {
        self.init(unsafeResultMap: ["__typename": "Vehicle", "make": make, "modelName": modelName, "year": year, "vin": vin, "mid": mid, "manufacturer": manufacturer, "bodyStyle": bodyStyle, "bodyType": bodyType, "trimName": trimName, "title": title, "vehicleType": vehicleType, "getBatteryTestInstructions": getBatteryTestInstructions.flatMap { (value: [GetBatteryTestInstruction]) -> [ResultMap] in value.map { (value: GetBatteryTestInstruction) -> ResultMap in value.resultMap } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// The brand or marquee used to describe the catalog vehicle made by an automotive manufacturer.
      public var make: String? {
        get {
          return resultMap["make"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "make")
        }
      }

      /// A standardized version of the Proposed Marketing Model Name that maintains consistency year over year.
      public var modelName: String? {
        get {
          return resultMap["modelName"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "modelName")
        }
      }

      /// A four-digit number to describe approximately when a catalog vehicle was produced and/or sold as 'New' in the market.
      public var year: Int? {
        get {
          return resultMap["year"] as? Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "year")
        }
      }

      /// The Vehicle Identification Number.
      public var vin: String? {
        get {
          return resultMap["vin"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "vin")
        }
      }

      /// The vehicle's Manheim ID.
      public var mid: String? {
        get {
          return resultMap["mid"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "mid")
        }
      }

      /// The business entity that owns the manufacturing facilities that build the catalog vehicle.
      public var manufacturer: String? {
        get {
          return resultMap["manufacturer"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "manufacturer")
        }
      }

      /// The identification of a vehicle's body type as the OEM describes it in brochures, press releases, consumer websites, and other public-facing information.
      public var bodyStyle: String? {
        get {
          return resultMap["bodyStyle"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "bodyStyle")
        }
      }

      /// A high-level, simplistic description of the vehicle based on general and easily identifiable attributes.
      public var bodyType: String? {
        get {
          return resultMap["bodyType"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "bodyType")
        }
      }

      /// A standardized version of the Proposed Marketing Trim Name that maintains consistency year over year.
      public var trimName: String? {
        get {
          return resultMap["trimName"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "trimName")
        }
      }

      /// A textual description of the catalog vehicle, typically containing the year, make, model, and trim.
      public var title: String? {
        get {
          return resultMap["title"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "title")
        }
      }

      /// A high-level, simplistic description of the vehicle based on general and easily identifiable attributes.
      public var vehicleType: String? {
        get {
          return resultMap["vehicleType"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "vehicleType")
        }
      }

      public var getBatteryTestInstructions: [GetBatteryTestInstruction]? {
        get {
          return (resultMap["getBatteryTestInstructions"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [GetBatteryTestInstruction] in value.map { (value: ResultMap) -> GetBatteryTestInstruction in GetBatteryTestInstruction(unsafeResultMap: value) } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [GetBatteryTestInstruction]) -> [ResultMap] in value.map { (value: GetBatteryTestInstruction) -> ResultMap in value.resultMap } }, forKey: "getBatteryTestInstructions")
        }
      }

      public struct GetBatteryTestInstruction: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["BatteryTestInstruction"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("testCommands", type: .nonNull(.object(TestCommand.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(testCommands: TestCommand) {
          self.init(unsafeResultMap: ["__typename": "BatteryTestInstruction", "testCommands": testCommands.resultMap])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var testCommands: TestCommand {
          get {
            return TestCommand(unsafeResultMap: resultMap["testCommands"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "testCommands")
          }
        }

        public struct TestCommand: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["ChallengeTestCommands", "BroadcastTestCommands"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLTypeCase(
                variants: ["ChallengeTestCommands": AsChallengeTestCommands.selections],
                default: [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                ]
              )
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public static func makeBroadcastTestCommands() -> TestCommand {
            return TestCommand(unsafeResultMap: ["__typename": "BroadcastTestCommands"])
          }

          public static func makeChallengeTestCommands(id: GraphQLID, vehicleProfile: AsChallengeTestCommands.VehicleProfile? = nil, odometer: AsChallengeTestCommands.Odometer? = nil, stateOfCharge: AsChallengeTestCommands.StateOfCharge? = nil, energyToEmpty: AsChallengeTestCommands.EnergyToEmpty? = nil, bmsCapacity: AsChallengeTestCommands.BmsCapacity? = nil, sampledCommands: AsChallengeTestCommands.SampledCommand? = nil, batteryAge: AsChallengeTestCommands.BatteryAge? = nil, diagnosticSession: AsChallengeTestCommands.DiagnosticSession? = nil, miscCommands: [AsChallengeTestCommands.MiscCommand?]? = nil) -> TestCommand {
            return TestCommand(unsafeResultMap: ["__typename": "ChallengeTestCommands", "id": id, "vehicleProfile": vehicleProfile.flatMap { (value: AsChallengeTestCommands.VehicleProfile) -> ResultMap in value.resultMap }, "odometer": odometer.flatMap { (value: AsChallengeTestCommands.Odometer) -> ResultMap in value.resultMap }, "stateOfCharge": stateOfCharge.flatMap { (value: AsChallengeTestCommands.StateOfCharge) -> ResultMap in value.resultMap }, "energyToEmpty": energyToEmpty.flatMap { (value: AsChallengeTestCommands.EnergyToEmpty) -> ResultMap in value.resultMap }, "bmsCapacity": bmsCapacity.flatMap { (value: AsChallengeTestCommands.BmsCapacity) -> ResultMap in value.resultMap }, "sampledCommands": sampledCommands.flatMap { (value: AsChallengeTestCommands.SampledCommand) -> ResultMap in value.resultMap }, "batteryAge": batteryAge.flatMap { (value: AsChallengeTestCommands.BatteryAge) -> ResultMap in value.resultMap }, "diagnosticSession": diagnosticSession.flatMap { (value: AsChallengeTestCommands.DiagnosticSession) -> ResultMap in value.resultMap }, "miscCommands": miscCommands.flatMap { (value: [AsChallengeTestCommands.MiscCommand?]) -> [ResultMap?] in value.map { (value: AsChallengeTestCommands.MiscCommand?) -> ResultMap? in value.flatMap { (value: AsChallengeTestCommands.MiscCommand) -> ResultMap in value.resultMap } } }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var asChallengeTestCommands: AsChallengeTestCommands? {
            get {
              if !AsChallengeTestCommands.possibleTypes.contains(__typename) { return nil }
              return AsChallengeTestCommands(unsafeResultMap: resultMap)
            }
            set {
              guard let newValue = newValue else { return }
              resultMap = newValue.resultMap
            }
          }

          public struct AsChallengeTestCommands: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["ChallengeTestCommands"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
                GraphQLField("vehicleProfile", type: .object(VehicleProfile.selections)),
                GraphQLField("odometer", type: .object(Odometer.selections)),
                GraphQLField("stateOfCharge", type: .object(StateOfCharge.selections)),
                GraphQLField("energyToEmpty", type: .object(EnergyToEmpty.selections)),
                GraphQLField("bmsCapacity", type: .object(BmsCapacity.selections)),
                GraphQLField("sampledCommands", type: .object(SampledCommand.selections)),
                GraphQLField("batteryAge", type: .object(BatteryAge.selections)),
                GraphQLField("diagnosticSession", type: .object(DiagnosticSession.selections)),
                GraphQLField("miscCommands", type: .list(.object(MiscCommand.selections))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(id: GraphQLID, vehicleProfile: VehicleProfile? = nil, odometer: Odometer? = nil, stateOfCharge: StateOfCharge? = nil, energyToEmpty: EnergyToEmpty? = nil, bmsCapacity: BmsCapacity? = nil, sampledCommands: SampledCommand? = nil, batteryAge: BatteryAge? = nil, diagnosticSession: DiagnosticSession? = nil, miscCommands: [MiscCommand?]? = nil) {
              self.init(unsafeResultMap: ["__typename": "ChallengeTestCommands", "id": id, "vehicleProfile": vehicleProfile.flatMap { (value: VehicleProfile) -> ResultMap in value.resultMap }, "odometer": odometer.flatMap { (value: Odometer) -> ResultMap in value.resultMap }, "stateOfCharge": stateOfCharge.flatMap { (value: StateOfCharge) -> ResultMap in value.resultMap }, "energyToEmpty": energyToEmpty.flatMap { (value: EnergyToEmpty) -> ResultMap in value.resultMap }, "bmsCapacity": bmsCapacity.flatMap { (value: BmsCapacity) -> ResultMap in value.resultMap }, "sampledCommands": sampledCommands.flatMap { (value: SampledCommand) -> ResultMap in value.resultMap }, "batteryAge": batteryAge.flatMap { (value: BatteryAge) -> ResultMap in value.resultMap }, "diagnosticSession": diagnosticSession.flatMap { (value: DiagnosticSession) -> ResultMap in value.resultMap }, "miscCommands": miscCommands.flatMap { (value: [MiscCommand?]) -> [ResultMap?] in value.map { (value: MiscCommand?) -> ResultMap? in value.flatMap { (value: MiscCommand) -> ResultMap in value.resultMap } } }])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// uuid
            public var id: GraphQLID {
              get {
                return resultMap["id"]! as! GraphQLID
              }
              set {
                resultMap.updateValue(newValue, forKey: "id")
              }
            }

            public var vehicleProfile: VehicleProfile? {
              get {
                return (resultMap["vehicleProfile"] as? ResultMap).flatMap { VehicleProfile(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "vehicleProfile")
              }
            }

            public var odometer: Odometer? {
              get {
                return (resultMap["odometer"] as? ResultMap).flatMap { Odometer(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "odometer")
              }
            }

            public var stateOfCharge: StateOfCharge? {
              get {
                return (resultMap["stateOfCharge"] as? ResultMap).flatMap { StateOfCharge(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "stateOfCharge")
              }
            }

            public var energyToEmpty: EnergyToEmpty? {
              get {
                return (resultMap["energyToEmpty"] as? ResultMap).flatMap { EnergyToEmpty(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "energyToEmpty")
              }
            }

            public var bmsCapacity: BmsCapacity? {
              get {
                return (resultMap["bmsCapacity"] as? ResultMap).flatMap { BmsCapacity(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "bmsCapacity")
              }
            }

            public var sampledCommands: SampledCommand? {
              get {
                return (resultMap["sampledCommands"] as? ResultMap).flatMap { SampledCommand(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "sampledCommands")
              }
            }

            public var batteryAge: BatteryAge? {
              get {
                return (resultMap["batteryAge"] as? ResultMap).flatMap { BatteryAge(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "batteryAge")
              }
            }

            /// on certain models, you must enter diagnostic mode first
            public var diagnosticSession: DiagnosticSession? {
              get {
                return (resultMap["diagnosticSession"] as? ResultMap).flatMap { DiagnosticSession(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "diagnosticSession")
              }
            }

            public var miscCommands: [MiscCommand?]? {
              get {
                return (resultMap["miscCommands"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [MiscCommand?] in value.map { (value: ResultMap?) -> MiscCommand? in value.flatMap { (value: ResultMap) -> MiscCommand in MiscCommand(unsafeResultMap: value) } } }
              }
              set {
                resultMap.updateValue(newValue.flatMap { (value: [MiscCommand?]) -> [ResultMap?] in value.map { (value: MiscCommand?) -> ResultMap? in value.flatMap { (value: MiscCommand) -> ResultMap in value.resultMap } } }, forKey: "miscCommands")
              }
            }

            public struct VehicleProfile: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["VehicleProfile"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("nominalVoltage", type: .nonNull(.scalar(Double.self))),
                  GraphQLField("energyAtBirth", type: .nonNull(.scalar(Double.self))),
                  GraphQLField("batteryType", type: .nonNull(.scalar(BatteryType.self))),
                  GraphQLField("capacityAtBirth", type: .nonNull(.scalar(Double.self))),
                  GraphQLField("rangeAtBirth", type: .scalar(Double.self)),
                  GraphQLField("designChargeCycles", type: .scalar(Double.self)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(nominalVoltage: Double, energyAtBirth: Double, batteryType: BatteryType, capacityAtBirth: Double, rangeAtBirth: Double? = nil, designChargeCycles: Double? = nil) {
                self.init(unsafeResultMap: ["__typename": "VehicleProfile", "nominalVoltage": nominalVoltage, "energyAtBirth": energyAtBirth, "batteryType": batteryType, "capacityAtBirth": capacityAtBirth, "rangeAtBirth": rangeAtBirth, "designChargeCycles": designChargeCycles])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var nominalVoltage: Double {
                get {
                  return resultMap["nominalVoltage"]! as! Double
                }
                set {
                  resultMap.updateValue(newValue, forKey: "nominalVoltage")
                }
              }

              public var energyAtBirth: Double {
                get {
                  return resultMap["energyAtBirth"]! as! Double
                }
                set {
                  resultMap.updateValue(newValue, forKey: "energyAtBirth")
                }
              }

              /// The battery's current type, matching one of the BatteryType enum values.
              public var batteryType: BatteryType {
                get {
                  return resultMap["batteryType"]! as! BatteryType
                }
                set {
                  resultMap.updateValue(newValue, forKey: "batteryType")
                }
              }

              public var capacityAtBirth: Double {
                get {
                  return resultMap["capacityAtBirth"]! as! Double
                }
                set {
                  resultMap.updateValue(newValue, forKey: "capacityAtBirth")
                }
              }

              public var rangeAtBirth: Double? {
                get {
                  return resultMap["rangeAtBirth"] as? Double
                }
                set {
                  resultMap.updateValue(newValue, forKey: "rangeAtBirth")
                }
              }

              public var designChargeCycles: Double? {
                get {
                  return resultMap["designChargeCycles"] as? Double
                }
                set {
                  resultMap.updateValue(newValue, forKey: "designChargeCycles")
                }
              }
            }

            public struct Odometer: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["ChallengeInstruction"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("protocol", type: .nonNull(.object(`Protocol`.selections))),
                  GraphQLField("challenge", type: .nonNull(.object(Challenge.selections))),
                  GraphQLField("response", type: .nonNull(.object(Response.selections))),
                  GraphQLField("validation", type: .nonNull(.object(Validation.selections))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(`protocol`: `Protocol`, challenge: Challenge, response: Response, validation: Validation) {
                self.init(unsafeResultMap: ["__typename": "ChallengeInstruction", "protocol": `protocol`.resultMap, "challenge": challenge.resultMap, "response": response.resultMap, "validation": validation.resultMap])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var `protocol`: `Protocol` {
                get {
                  return `Protocol`(unsafeResultMap: resultMap["protocol"]! as! ResultMap)
                }
                set {
                  resultMap.updateValue(newValue.resultMap, forKey: "protocol")
                }
              }

              public var challenge: Challenge {
                get {
                  return Challenge(unsafeResultMap: resultMap["challenge"]! as! ResultMap)
                }
                set {
                  resultMap.updateValue(newValue.resultMap, forKey: "challenge")
                }
              }

              public var response: Response {
                get {
                  return Response(unsafeResultMap: resultMap["response"]! as! ResultMap)
                }
                set {
                  resultMap.updateValue(newValue.resultMap, forKey: "response")
                }
              }

              public var validation: Validation {
                get {
                  return Validation(unsafeResultMap: resultMap["validation"]! as! ResultMap)
                }
                set {
                  resultMap.updateValue(newValue.resultMap, forKey: "validation")
                }
              }

              public struct `Protocol`: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["OBD2Protocol"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("elm327ProtocolPreset", type: .scalar(ELM327ProtocolPreset.self)),
                    GraphQLField("obdLinkProtocolPreset", type: .scalar(OBDLinkProtocolPreset.self)),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(elm327ProtocolPreset: ELM327ProtocolPreset? = nil, obdLinkProtocolPreset: OBDLinkProtocolPreset? = nil) {
                  self.init(unsafeResultMap: ["__typename": "OBD2Protocol", "elm327ProtocolPreset": elm327ProtocolPreset, "obdLinkProtocolPreset": obdLinkProtocolPreset])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// elm327ProtocolPreset will be null if obdLinkProtocolPreset doesn't map to elm327ProtocolPreset ENUM
                public var elm327ProtocolPreset: ELM327ProtocolPreset? {
                  get {
                    return resultMap["elm327ProtocolPreset"] as? ELM327ProtocolPreset
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "elm327ProtocolPreset")
                  }
                }

                /// obdLinkProtocolPreset will be null if options is provided upon on creation
                public var obdLinkProtocolPreset: OBDLinkProtocolPreset? {
                  get {
                    return resultMap["obdLinkProtocolPreset"] as? OBDLinkProtocolPreset
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "obdLinkProtocolPreset")
                  }
                }
              }

              public struct Challenge: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Challenge"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("canFilter", type: .scalar(String.self)),
                    GraphQLField("canMask", type: .scalar(String.self)),
                    GraphQLField("header", type: .nonNull(.scalar(String.self))),
                    GraphQLField("pid", type: .nonNull(.scalar(String.self))),
                    GraphQLField("flowControl", type: .object(FlowControl.selections)),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(canFilter: String? = nil, canMask: String? = nil, header: String, pid: String, flowControl: FlowControl? = nil) {
                  self.init(unsafeResultMap: ["__typename": "Challenge", "canFilter": canFilter, "canMask": canMask, "header": header, "pid": pid, "flowControl": flowControl.flatMap { (value: FlowControl) -> ResultMap in value.resultMap }])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                public var canFilter: String? {
                  get {
                    return resultMap["canFilter"] as? String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "canFilter")
                  }
                }

                public var canMask: String? {
                  get {
                    return resultMap["canMask"] as? String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "canMask")
                  }
                }

                public var header: String {
                  get {
                    return resultMap["header"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "header")
                  }
                }

                /// OBD-II PIDs; 8 bytes of data in hex. (Pad right if you not provided)
                public var pid: String {
                  get {
                    return resultMap["pid"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "pid")
                  }
                }

                public var flowControl: FlowControl? {
                  get {
                    return (resultMap["flowControl"] as? ResultMap).flatMap { FlowControl(unsafeResultMap: $0) }
                  }
                  set {
                    resultMap.updateValue(newValue?.resultMap, forKey: "flowControl")
                  }
                }

                public struct FlowControl: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["FlowControl"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("flowControlHeader", type: .nonNull(.scalar(String.self))),
                      GraphQLField("flowControlData", type: .nonNull(.scalar(String.self))),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(flowControlHeader: String, flowControlData: String) {
                    self.init(unsafeResultMap: ["__typename": "FlowControl", "flowControlHeader": flowControlHeader, "flowControlData": flowControlData])
                  }

                  public var __typename: String {
                    get {
                      return resultMap["__typename"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  public var flowControlHeader: String {
                    get {
                      return resultMap["flowControlHeader"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "flowControlHeader")
                    }
                  }

                  public var flowControlData: String {
                    get {
                      return resultMap["flowControlData"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "flowControlData")
                    }
                  }
                }
              }

              public struct Response: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["ChallengeResponse"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("startByte", type: .nonNull(.scalar(Int.self))),
                    GraphQLField("endByte", type: .nonNull(.scalar(Int.self))),
                    GraphQLField("multiplier", type: .nonNull(.scalar(Double.self))),
                    GraphQLField("constant", type: .nonNull(.scalar(Double.self))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(startByte: Int, endByte: Int, multiplier: Double, constant: Double) {
                  self.init(unsafeResultMap: ["__typename": "ChallengeResponse", "startByte": startByte, "endByte": endByte, "multiplier": multiplier, "constant": constant])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// The first byte of relevant data
                public var startByte: Int {
                  get {
                    return resultMap["startByte"]! as! Int
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "startByte")
                  }
                }

                /// The last byte of relevant data
                public var endByte: Int {
                  get {
                    return resultMap["endByte"]! as! Int
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "endByte")
                  }
                }

                /// multiplier to apply to bytes hex value.
                /// hexToDec(Bytes Value) * multiplier + constant = Human Readable value
                public var multiplier: Double {
                  get {
                    return resultMap["multiplier"]! as! Double
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "multiplier")
                  }
                }

                /// constant to add to bytes hex value.
                /// hexToDec(Bytes Value) * multiplier + constant = Human Readable value
                public var constant: Double {
                  get {
                    return resultMap["constant"]! as! Double
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "constant")
                  }
                }
              }

              public struct Validation: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["ChallengeValidation"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("numberOfFrames", type: .nonNull(.scalar(Int.self))),
                    GraphQLField("lowerBounds", type: .nonNull(.scalar(Double.self))),
                    GraphQLField("upperBounds", type: .nonNull(.scalar(Double.self))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(numberOfFrames: Int, lowerBounds: Double, upperBounds: Double) {
                  self.init(unsafeResultMap: ["__typename": "ChallengeValidation", "numberOfFrames": numberOfFrames, "lowerBounds": lowerBounds, "upperBounds": upperBounds])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// number of expected frames
                public var numberOfFrames: Int {
                  get {
                    return resultMap["numberOfFrames"]! as! Int
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "numberOfFrames")
                  }
                }

                /// Lowest possible value after applying multiplier + constant
                public var lowerBounds: Double {
                  get {
                    return resultMap["lowerBounds"]! as! Double
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "lowerBounds")
                  }
                }

                /// Highest possible value after applying multiplier + constant
                public var upperBounds: Double {
                  get {
                    return resultMap["upperBounds"]! as! Double
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "upperBounds")
                  }
                }
              }
            }

            public struct StateOfCharge: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["ChallengeInstruction"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("protocol", type: .nonNull(.object(`Protocol`.selections))),
                  GraphQLField("validation", type: .nonNull(.object(Validation.selections))),
                  GraphQLField("challenge", type: .nonNull(.object(Challenge.selections))),
                  GraphQLField("response", type: .nonNull(.object(Response.selections))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(`protocol`: `Protocol`, validation: Validation, challenge: Challenge, response: Response) {
                self.init(unsafeResultMap: ["__typename": "ChallengeInstruction", "protocol": `protocol`.resultMap, "validation": validation.resultMap, "challenge": challenge.resultMap, "response": response.resultMap])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var `protocol`: `Protocol` {
                get {
                  return `Protocol`(unsafeResultMap: resultMap["protocol"]! as! ResultMap)
                }
                set {
                  resultMap.updateValue(newValue.resultMap, forKey: "protocol")
                }
              }

              public var validation: Validation {
                get {
                  return Validation(unsafeResultMap: resultMap["validation"]! as! ResultMap)
                }
                set {
                  resultMap.updateValue(newValue.resultMap, forKey: "validation")
                }
              }

              public var challenge: Challenge {
                get {
                  return Challenge(unsafeResultMap: resultMap["challenge"]! as! ResultMap)
                }
                set {
                  resultMap.updateValue(newValue.resultMap, forKey: "challenge")
                }
              }

              public var response: Response {
                get {
                  return Response(unsafeResultMap: resultMap["response"]! as! ResultMap)
                }
                set {
                  resultMap.updateValue(newValue.resultMap, forKey: "response")
                }
              }

              public struct `Protocol`: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["OBD2Protocol"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("elm327ProtocolPreset", type: .scalar(ELM327ProtocolPreset.self)),
                    GraphQLField("obdLinkProtocolPreset", type: .scalar(OBDLinkProtocolPreset.self)),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(elm327ProtocolPreset: ELM327ProtocolPreset? = nil, obdLinkProtocolPreset: OBDLinkProtocolPreset? = nil) {
                  self.init(unsafeResultMap: ["__typename": "OBD2Protocol", "elm327ProtocolPreset": elm327ProtocolPreset, "obdLinkProtocolPreset": obdLinkProtocolPreset])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// elm327ProtocolPreset will be null if obdLinkProtocolPreset doesn't map to elm327ProtocolPreset ENUM
                public var elm327ProtocolPreset: ELM327ProtocolPreset? {
                  get {
                    return resultMap["elm327ProtocolPreset"] as? ELM327ProtocolPreset
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "elm327ProtocolPreset")
                  }
                }

                /// obdLinkProtocolPreset will be null if options is provided upon on creation
                public var obdLinkProtocolPreset: OBDLinkProtocolPreset? {
                  get {
                    return resultMap["obdLinkProtocolPreset"] as? OBDLinkProtocolPreset
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "obdLinkProtocolPreset")
                  }
                }
              }

              public struct Validation: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["ChallengeValidation"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("upperBounds", type: .nonNull(.scalar(Double.self))),
                    GraphQLField("lowerBounds", type: .nonNull(.scalar(Double.self))),
                    GraphQLField("numberOfFrames", type: .nonNull(.scalar(Int.self))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(upperBounds: Double, lowerBounds: Double, numberOfFrames: Int) {
                  self.init(unsafeResultMap: ["__typename": "ChallengeValidation", "upperBounds": upperBounds, "lowerBounds": lowerBounds, "numberOfFrames": numberOfFrames])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// Highest possible value after applying multiplier + constant
                public var upperBounds: Double {
                  get {
                    return resultMap["upperBounds"]! as! Double
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "upperBounds")
                  }
                }

                /// Lowest possible value after applying multiplier + constant
                public var lowerBounds: Double {
                  get {
                    return resultMap["lowerBounds"]! as! Double
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "lowerBounds")
                  }
                }

                /// number of expected frames
                public var numberOfFrames: Int {
                  get {
                    return resultMap["numberOfFrames"]! as! Int
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "numberOfFrames")
                  }
                }
              }

              public struct Challenge: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Challenge"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("canFilter", type: .scalar(String.self)),
                    GraphQLField("canMask", type: .scalar(String.self)),
                    GraphQLField("header", type: .nonNull(.scalar(String.self))),
                    GraphQLField("pid", type: .nonNull(.scalar(String.self))),
                    GraphQLField("flowControl", type: .object(FlowControl.selections)),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(canFilter: String? = nil, canMask: String? = nil, header: String, pid: String, flowControl: FlowControl? = nil) {
                  self.init(unsafeResultMap: ["__typename": "Challenge", "canFilter": canFilter, "canMask": canMask, "header": header, "pid": pid, "flowControl": flowControl.flatMap { (value: FlowControl) -> ResultMap in value.resultMap }])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                public var canFilter: String? {
                  get {
                    return resultMap["canFilter"] as? String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "canFilter")
                  }
                }

                public var canMask: String? {
                  get {
                    return resultMap["canMask"] as? String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "canMask")
                  }
                }

                public var header: String {
                  get {
                    return resultMap["header"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "header")
                  }
                }

                /// OBD-II PIDs; 8 bytes of data in hex. (Pad right if you not provided)
                public var pid: String {
                  get {
                    return resultMap["pid"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "pid")
                  }
                }

                public var flowControl: FlowControl? {
                  get {
                    return (resultMap["flowControl"] as? ResultMap).flatMap { FlowControl(unsafeResultMap: $0) }
                  }
                  set {
                    resultMap.updateValue(newValue?.resultMap, forKey: "flowControl")
                  }
                }

                public struct FlowControl: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["FlowControl"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("flowControlHeader", type: .nonNull(.scalar(String.self))),
                      GraphQLField("flowControlData", type: .nonNull(.scalar(String.self))),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(flowControlHeader: String, flowControlData: String) {
                    self.init(unsafeResultMap: ["__typename": "FlowControl", "flowControlHeader": flowControlHeader, "flowControlData": flowControlData])
                  }

                  public var __typename: String {
                    get {
                      return resultMap["__typename"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  public var flowControlHeader: String {
                    get {
                      return resultMap["flowControlHeader"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "flowControlHeader")
                    }
                  }

                  public var flowControlData: String {
                    get {
                      return resultMap["flowControlData"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "flowControlData")
                    }
                  }
                }
              }

              public struct Response: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["ChallengeResponse"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("constant", type: .nonNull(.scalar(Double.self))),
                    GraphQLField("multiplier", type: .nonNull(.scalar(Double.self))),
                    GraphQLField("startByte", type: .nonNull(.scalar(Int.self))),
                    GraphQLField("endByte", type: .nonNull(.scalar(Int.self))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(constant: Double, multiplier: Double, startByte: Int, endByte: Int) {
                  self.init(unsafeResultMap: ["__typename": "ChallengeResponse", "constant": constant, "multiplier": multiplier, "startByte": startByte, "endByte": endByte])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// constant to add to bytes hex value.
                /// hexToDec(Bytes Value) * multiplier + constant = Human Readable value
                public var constant: Double {
                  get {
                    return resultMap["constant"]! as! Double
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "constant")
                  }
                }

                /// multiplier to apply to bytes hex value.
                /// hexToDec(Bytes Value) * multiplier + constant = Human Readable value
                public var multiplier: Double {
                  get {
                    return resultMap["multiplier"]! as! Double
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "multiplier")
                  }
                }

                /// The first byte of relevant data
                public var startByte: Int {
                  get {
                    return resultMap["startByte"]! as! Int
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "startByte")
                  }
                }

                /// The last byte of relevant data
                public var endByte: Int {
                  get {
                    return resultMap["endByte"]! as! Int
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "endByte")
                  }
                }
              }
            }

            public struct EnergyToEmpty: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["ChallengeInstruction"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("protocol", type: .nonNull(.object(`Protocol`.selections))),
                  GraphQLField("challenge", type: .nonNull(.object(Challenge.selections))),
                  GraphQLField("response", type: .nonNull(.object(Response.selections))),
                  GraphQLField("validation", type: .nonNull(.object(Validation.selections))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(`protocol`: `Protocol`, challenge: Challenge, response: Response, validation: Validation) {
                self.init(unsafeResultMap: ["__typename": "ChallengeInstruction", "protocol": `protocol`.resultMap, "challenge": challenge.resultMap, "response": response.resultMap, "validation": validation.resultMap])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var `protocol`: `Protocol` {
                get {
                  return `Protocol`(unsafeResultMap: resultMap["protocol"]! as! ResultMap)
                }
                set {
                  resultMap.updateValue(newValue.resultMap, forKey: "protocol")
                }
              }

              public var challenge: Challenge {
                get {
                  return Challenge(unsafeResultMap: resultMap["challenge"]! as! ResultMap)
                }
                set {
                  resultMap.updateValue(newValue.resultMap, forKey: "challenge")
                }
              }

              public var response: Response {
                get {
                  return Response(unsafeResultMap: resultMap["response"]! as! ResultMap)
                }
                set {
                  resultMap.updateValue(newValue.resultMap, forKey: "response")
                }
              }

              public var validation: Validation {
                get {
                  return Validation(unsafeResultMap: resultMap["validation"]! as! ResultMap)
                }
                set {
                  resultMap.updateValue(newValue.resultMap, forKey: "validation")
                }
              }

              public struct `Protocol`: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["OBD2Protocol"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("elm327ProtocolPreset", type: .scalar(ELM327ProtocolPreset.self)),
                    GraphQLField("obdLinkProtocolPreset", type: .scalar(OBDLinkProtocolPreset.self)),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(elm327ProtocolPreset: ELM327ProtocolPreset? = nil, obdLinkProtocolPreset: OBDLinkProtocolPreset? = nil) {
                  self.init(unsafeResultMap: ["__typename": "OBD2Protocol", "elm327ProtocolPreset": elm327ProtocolPreset, "obdLinkProtocolPreset": obdLinkProtocolPreset])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// elm327ProtocolPreset will be null if obdLinkProtocolPreset doesn't map to elm327ProtocolPreset ENUM
                public var elm327ProtocolPreset: ELM327ProtocolPreset? {
                  get {
                    return resultMap["elm327ProtocolPreset"] as? ELM327ProtocolPreset
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "elm327ProtocolPreset")
                  }
                }

                /// obdLinkProtocolPreset will be null if options is provided upon on creation
                public var obdLinkProtocolPreset: OBDLinkProtocolPreset? {
                  get {
                    return resultMap["obdLinkProtocolPreset"] as? OBDLinkProtocolPreset
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "obdLinkProtocolPreset")
                  }
                }
              }

              public struct Challenge: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Challenge"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("canFilter", type: .scalar(String.self)),
                    GraphQLField("canMask", type: .scalar(String.self)),
                    GraphQLField("header", type: .nonNull(.scalar(String.self))),
                    GraphQLField("pid", type: .nonNull(.scalar(String.self))),
                    GraphQLField("flowControl", type: .object(FlowControl.selections)),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(canFilter: String? = nil, canMask: String? = nil, header: String, pid: String, flowControl: FlowControl? = nil) {
                  self.init(unsafeResultMap: ["__typename": "Challenge", "canFilter": canFilter, "canMask": canMask, "header": header, "pid": pid, "flowControl": flowControl.flatMap { (value: FlowControl) -> ResultMap in value.resultMap }])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                public var canFilter: String? {
                  get {
                    return resultMap["canFilter"] as? String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "canFilter")
                  }
                }

                public var canMask: String? {
                  get {
                    return resultMap["canMask"] as? String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "canMask")
                  }
                }

                public var header: String {
                  get {
                    return resultMap["header"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "header")
                  }
                }

                /// OBD-II PIDs; 8 bytes of data in hex. (Pad right if you not provided)
                public var pid: String {
                  get {
                    return resultMap["pid"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "pid")
                  }
                }

                public var flowControl: FlowControl? {
                  get {
                    return (resultMap["flowControl"] as? ResultMap).flatMap { FlowControl(unsafeResultMap: $0) }
                  }
                  set {
                    resultMap.updateValue(newValue?.resultMap, forKey: "flowControl")
                  }
                }

                public struct FlowControl: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["FlowControl"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("flowControlHeader", type: .nonNull(.scalar(String.self))),
                      GraphQLField("flowControlData", type: .nonNull(.scalar(String.self))),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(flowControlHeader: String, flowControlData: String) {
                    self.init(unsafeResultMap: ["__typename": "FlowControl", "flowControlHeader": flowControlHeader, "flowControlData": flowControlData])
                  }

                  public var __typename: String {
                    get {
                      return resultMap["__typename"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  public var flowControlHeader: String {
                    get {
                      return resultMap["flowControlHeader"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "flowControlHeader")
                    }
                  }

                  public var flowControlData: String {
                    get {
                      return resultMap["flowControlData"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "flowControlData")
                    }
                  }
                }
              }

              public struct Response: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["ChallengeResponse"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("startByte", type: .nonNull(.scalar(Int.self))),
                    GraphQLField("endByte", type: .nonNull(.scalar(Int.self))),
                    GraphQLField("multiplier", type: .nonNull(.scalar(Double.self))),
                    GraphQLField("constant", type: .nonNull(.scalar(Double.self))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(startByte: Int, endByte: Int, multiplier: Double, constant: Double) {
                  self.init(unsafeResultMap: ["__typename": "ChallengeResponse", "startByte": startByte, "endByte": endByte, "multiplier": multiplier, "constant": constant])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// The first byte of relevant data
                public var startByte: Int {
                  get {
                    return resultMap["startByte"]! as! Int
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "startByte")
                  }
                }

                /// The last byte of relevant data
                public var endByte: Int {
                  get {
                    return resultMap["endByte"]! as! Int
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "endByte")
                  }
                }

                /// multiplier to apply to bytes hex value.
                /// hexToDec(Bytes Value) * multiplier + constant = Human Readable value
                public var multiplier: Double {
                  get {
                    return resultMap["multiplier"]! as! Double
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "multiplier")
                  }
                }

                /// constant to add to bytes hex value.
                /// hexToDec(Bytes Value) * multiplier + constant = Human Readable value
                public var constant: Double {
                  get {
                    return resultMap["constant"]! as! Double
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "constant")
                  }
                }
              }

              public struct Validation: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["ChallengeValidation"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("numberOfFrames", type: .nonNull(.scalar(Int.self))),
                    GraphQLField("lowerBounds", type: .nonNull(.scalar(Double.self))),
                    GraphQLField("upperBounds", type: .nonNull(.scalar(Double.self))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(numberOfFrames: Int, lowerBounds: Double, upperBounds: Double) {
                  self.init(unsafeResultMap: ["__typename": "ChallengeValidation", "numberOfFrames": numberOfFrames, "lowerBounds": lowerBounds, "upperBounds": upperBounds])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// number of expected frames
                public var numberOfFrames: Int {
                  get {
                    return resultMap["numberOfFrames"]! as! Int
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "numberOfFrames")
                  }
                }

                /// Lowest possible value after applying multiplier + constant
                public var lowerBounds: Double {
                  get {
                    return resultMap["lowerBounds"]! as! Double
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "lowerBounds")
                  }
                }

                /// Highest possible value after applying multiplier + constant
                public var upperBounds: Double {
                  get {
                    return resultMap["upperBounds"]! as! Double
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "upperBounds")
                  }
                }
              }
            }

            public struct BmsCapacity: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["ChallengeInstruction"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("challenge", type: .nonNull(.object(Challenge.selections))),
                  GraphQLField("protocol", type: .nonNull(.object(`Protocol`.selections))),
                  GraphQLField("response", type: .nonNull(.object(Response.selections))),
                  GraphQLField("validation", type: .nonNull(.object(Validation.selections))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(challenge: Challenge, `protocol`: `Protocol`, response: Response, validation: Validation) {
                self.init(unsafeResultMap: ["__typename": "ChallengeInstruction", "challenge": challenge.resultMap, "protocol": `protocol`.resultMap, "response": response.resultMap, "validation": validation.resultMap])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var challenge: Challenge {
                get {
                  return Challenge(unsafeResultMap: resultMap["challenge"]! as! ResultMap)
                }
                set {
                  resultMap.updateValue(newValue.resultMap, forKey: "challenge")
                }
              }

              public var `protocol`: `Protocol` {
                get {
                  return `Protocol`(unsafeResultMap: resultMap["protocol"]! as! ResultMap)
                }
                set {
                  resultMap.updateValue(newValue.resultMap, forKey: "protocol")
                }
              }

              public var response: Response {
                get {
                  return Response(unsafeResultMap: resultMap["response"]! as! ResultMap)
                }
                set {
                  resultMap.updateValue(newValue.resultMap, forKey: "response")
                }
              }

              public var validation: Validation {
                get {
                  return Validation(unsafeResultMap: resultMap["validation"]! as! ResultMap)
                }
                set {
                  resultMap.updateValue(newValue.resultMap, forKey: "validation")
                }
              }

              public struct Challenge: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Challenge"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("canFilter", type: .scalar(String.self)),
                    GraphQLField("canMask", type: .scalar(String.self)),
                    GraphQLField("header", type: .nonNull(.scalar(String.self))),
                    GraphQLField("pid", type: .nonNull(.scalar(String.self))),
                    GraphQLField("flowControl", type: .object(FlowControl.selections)),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(canFilter: String? = nil, canMask: String? = nil, header: String, pid: String, flowControl: FlowControl? = nil) {
                  self.init(unsafeResultMap: ["__typename": "Challenge", "canFilter": canFilter, "canMask": canMask, "header": header, "pid": pid, "flowControl": flowControl.flatMap { (value: FlowControl) -> ResultMap in value.resultMap }])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                public var canFilter: String? {
                  get {
                    return resultMap["canFilter"] as? String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "canFilter")
                  }
                }

                public var canMask: String? {
                  get {
                    return resultMap["canMask"] as? String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "canMask")
                  }
                }

                public var header: String {
                  get {
                    return resultMap["header"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "header")
                  }
                }

                /// OBD-II PIDs; 8 bytes of data in hex. (Pad right if you not provided)
                public var pid: String {
                  get {
                    return resultMap["pid"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "pid")
                  }
                }

                public var flowControl: FlowControl? {
                  get {
                    return (resultMap["flowControl"] as? ResultMap).flatMap { FlowControl(unsafeResultMap: $0) }
                  }
                  set {
                    resultMap.updateValue(newValue?.resultMap, forKey: "flowControl")
                  }
                }

                public struct FlowControl: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["FlowControl"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("flowControlHeader", type: .nonNull(.scalar(String.self))),
                      GraphQLField("flowControlData", type: .nonNull(.scalar(String.self))),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(flowControlHeader: String, flowControlData: String) {
                    self.init(unsafeResultMap: ["__typename": "FlowControl", "flowControlHeader": flowControlHeader, "flowControlData": flowControlData])
                  }

                  public var __typename: String {
                    get {
                      return resultMap["__typename"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  public var flowControlHeader: String {
                    get {
                      return resultMap["flowControlHeader"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "flowControlHeader")
                    }
                  }

                  public var flowControlData: String {
                    get {
                      return resultMap["flowControlData"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "flowControlData")
                    }
                  }
                }
              }

              public struct `Protocol`: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["OBD2Protocol"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("elm327ProtocolPreset", type: .scalar(ELM327ProtocolPreset.self)),
                    GraphQLField("obdLinkProtocolPreset", type: .scalar(OBDLinkProtocolPreset.self)),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(elm327ProtocolPreset: ELM327ProtocolPreset? = nil, obdLinkProtocolPreset: OBDLinkProtocolPreset? = nil) {
                  self.init(unsafeResultMap: ["__typename": "OBD2Protocol", "elm327ProtocolPreset": elm327ProtocolPreset, "obdLinkProtocolPreset": obdLinkProtocolPreset])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// elm327ProtocolPreset will be null if obdLinkProtocolPreset doesn't map to elm327ProtocolPreset ENUM
                public var elm327ProtocolPreset: ELM327ProtocolPreset? {
                  get {
                    return resultMap["elm327ProtocolPreset"] as? ELM327ProtocolPreset
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "elm327ProtocolPreset")
                  }
                }

                /// obdLinkProtocolPreset will be null if options is provided upon on creation
                public var obdLinkProtocolPreset: OBDLinkProtocolPreset? {
                  get {
                    return resultMap["obdLinkProtocolPreset"] as? OBDLinkProtocolPreset
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "obdLinkProtocolPreset")
                  }
                }
              }

              public struct Response: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["ChallengeResponse"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("constant", type: .nonNull(.scalar(Double.self))),
                    GraphQLField("endByte", type: .nonNull(.scalar(Int.self))),
                    GraphQLField("startByte", type: .nonNull(.scalar(Int.self))),
                    GraphQLField("multiplier", type: .nonNull(.scalar(Double.self))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(constant: Double, endByte: Int, startByte: Int, multiplier: Double) {
                  self.init(unsafeResultMap: ["__typename": "ChallengeResponse", "constant": constant, "endByte": endByte, "startByte": startByte, "multiplier": multiplier])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// constant to add to bytes hex value.
                /// hexToDec(Bytes Value) * multiplier + constant = Human Readable value
                public var constant: Double {
                  get {
                    return resultMap["constant"]! as! Double
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "constant")
                  }
                }

                /// The last byte of relevant data
                public var endByte: Int {
                  get {
                    return resultMap["endByte"]! as! Int
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "endByte")
                  }
                }

                /// The first byte of relevant data
                public var startByte: Int {
                  get {
                    return resultMap["startByte"]! as! Int
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "startByte")
                  }
                }

                /// multiplier to apply to bytes hex value.
                /// hexToDec(Bytes Value) * multiplier + constant = Human Readable value
                public var multiplier: Double {
                  get {
                    return resultMap["multiplier"]! as! Double
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "multiplier")
                  }
                }
              }

              public struct Validation: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["ChallengeValidation"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("lowerBounds", type: .nonNull(.scalar(Double.self))),
                    GraphQLField("upperBounds", type: .nonNull(.scalar(Double.self))),
                    GraphQLField("numberOfFrames", type: .nonNull(.scalar(Int.self))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(lowerBounds: Double, upperBounds: Double, numberOfFrames: Int) {
                  self.init(unsafeResultMap: ["__typename": "ChallengeValidation", "lowerBounds": lowerBounds, "upperBounds": upperBounds, "numberOfFrames": numberOfFrames])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// Lowest possible value after applying multiplier + constant
                public var lowerBounds: Double {
                  get {
                    return resultMap["lowerBounds"]! as! Double
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "lowerBounds")
                  }
                }

                /// Highest possible value after applying multiplier + constant
                public var upperBounds: Double {
                  get {
                    return resultMap["upperBounds"]! as! Double
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "upperBounds")
                  }
                }

                /// number of expected frames
                public var numberOfFrames: Int {
                  get {
                    return resultMap["numberOfFrames"]! as! Int
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "numberOfFrames")
                  }
                }
              }
            }

            public struct SampledCommand: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["SampledCommands"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("protocol", type: .nonNull(.object(`Protocol`.selections))),
                  GraphQLField("packTemperature", type: .list(.nonNull(.object(PackTemperature.selections)))),
                  GraphQLField("packVoltage", type: .object(PackVoltage.selections)),
                  GraphQLField("packCurrent", type: .object(PackCurrent.selections)),
                  GraphQLField("cellVoltage", type: .list(.nonNull(.object(CellVoltage.selections)))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(`protocol`: `Protocol`, packTemperature: [PackTemperature]? = nil, packVoltage: PackVoltage? = nil, packCurrent: PackCurrent? = nil, cellVoltage: [CellVoltage]? = nil) {
                self.init(unsafeResultMap: ["__typename": "SampledCommands", "protocol": `protocol`.resultMap, "packTemperature": packTemperature.flatMap { (value: [PackTemperature]) -> [ResultMap] in value.map { (value: PackTemperature) -> ResultMap in value.resultMap } }, "packVoltage": packVoltage.flatMap { (value: PackVoltage) -> ResultMap in value.resultMap }, "packCurrent": packCurrent.flatMap { (value: PackCurrent) -> ResultMap in value.resultMap }, "cellVoltage": cellVoltage.flatMap { (value: [CellVoltage]) -> [ResultMap] in value.map { (value: CellVoltage) -> ResultMap in value.resultMap } }])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var `protocol`: `Protocol` {
                get {
                  return `Protocol`(unsafeResultMap: resultMap["protocol"]! as! ResultMap)
                }
                set {
                  resultMap.updateValue(newValue.resultMap, forKey: "protocol")
                }
              }

              public var packTemperature: [PackTemperature]? {
                get {
                  return (resultMap["packTemperature"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [PackTemperature] in value.map { (value: ResultMap) -> PackTemperature in PackTemperature(unsafeResultMap: value) } }
                }
                set {
                  resultMap.updateValue(newValue.flatMap { (value: [PackTemperature]) -> [ResultMap] in value.map { (value: PackTemperature) -> ResultMap in value.resultMap } }, forKey: "packTemperature")
                }
              }

              public var packVoltage: PackVoltage? {
                get {
                  return (resultMap["packVoltage"] as? ResultMap).flatMap { PackVoltage(unsafeResultMap: $0) }
                }
                set {
                  resultMap.updateValue(newValue?.resultMap, forKey: "packVoltage")
                }
              }

              public var packCurrent: PackCurrent? {
                get {
                  return (resultMap["packCurrent"] as? ResultMap).flatMap { PackCurrent(unsafeResultMap: $0) }
                }
                set {
                  resultMap.updateValue(newValue?.resultMap, forKey: "packCurrent")
                }
              }

              public var cellVoltage: [CellVoltage]? {
                get {
                  return (resultMap["cellVoltage"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [CellVoltage] in value.map { (value: ResultMap) -> CellVoltage in CellVoltage(unsafeResultMap: value) } }
                }
                set {
                  resultMap.updateValue(newValue.flatMap { (value: [CellVoltage]) -> [ResultMap] in value.map { (value: CellVoltage) -> ResultMap in value.resultMap } }, forKey: "cellVoltage")
                }
              }

              public struct `Protocol`: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["OBD2Protocol"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("elm327ProtocolPreset", type: .scalar(ELM327ProtocolPreset.self)),
                    GraphQLField("obdLinkProtocolPreset", type: .scalar(OBDLinkProtocolPreset.self)),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(elm327ProtocolPreset: ELM327ProtocolPreset? = nil, obdLinkProtocolPreset: OBDLinkProtocolPreset? = nil) {
                  self.init(unsafeResultMap: ["__typename": "OBD2Protocol", "elm327ProtocolPreset": elm327ProtocolPreset, "obdLinkProtocolPreset": obdLinkProtocolPreset])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// elm327ProtocolPreset will be null if obdLinkProtocolPreset doesn't map to elm327ProtocolPreset ENUM
                public var elm327ProtocolPreset: ELM327ProtocolPreset? {
                  get {
                    return resultMap["elm327ProtocolPreset"] as? ELM327ProtocolPreset
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "elm327ProtocolPreset")
                  }
                }

                /// obdLinkProtocolPreset will be null if options is provided upon on creation
                public var obdLinkProtocolPreset: OBDLinkProtocolPreset? {
                  get {
                    return resultMap["obdLinkProtocolPreset"] as? OBDLinkProtocolPreset
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "obdLinkProtocolPreset")
                  }
                }
              }

              public struct PackTemperature: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["PackTemperatureChallengeInstruction"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("challenge", type: .nonNull(.object(Challenge.selections))),
                    GraphQLField("response", type: .nonNull(.object(Response.selections))),
                    GraphQLField("validation", type: .nonNull(.object(Validation.selections))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(challenge: Challenge, response: Response, validation: Validation) {
                  self.init(unsafeResultMap: ["__typename": "PackTemperatureChallengeInstruction", "challenge": challenge.resultMap, "response": response.resultMap, "validation": validation.resultMap])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                public var challenge: Challenge {
                  get {
                    return Challenge(unsafeResultMap: resultMap["challenge"]! as! ResultMap)
                  }
                  set {
                    resultMap.updateValue(newValue.resultMap, forKey: "challenge")
                  }
                }

                public var response: Response {
                  get {
                    return Response(unsafeResultMap: resultMap["response"]! as! ResultMap)
                  }
                  set {
                    resultMap.updateValue(newValue.resultMap, forKey: "response")
                  }
                }

                public var validation: Validation {
                  get {
                    return Validation(unsafeResultMap: resultMap["validation"]! as! ResultMap)
                  }
                  set {
                    resultMap.updateValue(newValue.resultMap, forKey: "validation")
                  }
                }

                public struct Challenge: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["Challenge"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("canFilter", type: .scalar(String.self)),
                      GraphQLField("canMask", type: .scalar(String.self)),
                      GraphQLField("header", type: .nonNull(.scalar(String.self))),
                      GraphQLField("pid", type: .nonNull(.scalar(String.self))),
                      GraphQLField("flowControl", type: .object(FlowControl.selections)),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(canFilter: String? = nil, canMask: String? = nil, header: String, pid: String, flowControl: FlowControl? = nil) {
                    self.init(unsafeResultMap: ["__typename": "Challenge", "canFilter": canFilter, "canMask": canMask, "header": header, "pid": pid, "flowControl": flowControl.flatMap { (value: FlowControl) -> ResultMap in value.resultMap }])
                  }

                  public var __typename: String {
                    get {
                      return resultMap["__typename"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  public var canFilter: String? {
                    get {
                      return resultMap["canFilter"] as? String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "canFilter")
                    }
                  }

                  public var canMask: String? {
                    get {
                      return resultMap["canMask"] as? String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "canMask")
                    }
                  }

                  public var header: String {
                    get {
                      return resultMap["header"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "header")
                    }
                  }

                  /// OBD-II PIDs; 8 bytes of data in hex. (Pad right if you not provided)
                  public var pid: String {
                    get {
                      return resultMap["pid"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "pid")
                    }
                  }

                  public var flowControl: FlowControl? {
                    get {
                      return (resultMap["flowControl"] as? ResultMap).flatMap { FlowControl(unsafeResultMap: $0) }
                    }
                    set {
                      resultMap.updateValue(newValue?.resultMap, forKey: "flowControl")
                    }
                  }

                  public struct FlowControl: GraphQLSelectionSet {
                    public static let possibleTypes: [String] = ["FlowControl"]

                    public static var selections: [GraphQLSelection] {
                      return [
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("flowControlHeader", type: .nonNull(.scalar(String.self))),
                        GraphQLField("flowControlData", type: .nonNull(.scalar(String.self))),
                      ]
                    }

                    public private(set) var resultMap: ResultMap

                    public init(unsafeResultMap: ResultMap) {
                      self.resultMap = unsafeResultMap
                    }

                    public init(flowControlHeader: String, flowControlData: String) {
                      self.init(unsafeResultMap: ["__typename": "FlowControl", "flowControlHeader": flowControlHeader, "flowControlData": flowControlData])
                    }

                    public var __typename: String {
                      get {
                        return resultMap["__typename"]! as! String
                      }
                      set {
                        resultMap.updateValue(newValue, forKey: "__typename")
                      }
                    }

                    public var flowControlHeader: String {
                      get {
                        return resultMap["flowControlHeader"]! as! String
                      }
                      set {
                        resultMap.updateValue(newValue, forKey: "flowControlHeader")
                      }
                    }

                    public var flowControlData: String {
                      get {
                        return resultMap["flowControlData"]! as! String
                      }
                      set {
                        resultMap.updateValue(newValue, forKey: "flowControlData")
                      }
                    }
                  }
                }

                public struct Response: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["PackTemperatureChallengeResponse"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("startByte", type: .nonNull(.scalar(Int.self))),
                      GraphQLField("endByte", type: .nonNull(.scalar(Int.self))),
                      GraphQLField("numberOfSensors", type: .nonNull(.scalar(Int.self))),
                      GraphQLField("bytesPerSensors", type: .nonNull(.scalar(Int.self))),
                      GraphQLField("startSensorsCount", type: .nonNull(.scalar(Int.self))),
                      GraphQLField("endSensorsCount", type: .nonNull(.scalar(Int.self))),
                      GraphQLField("bytesPaddedBetweenSensors", type: .nonNull(.scalar(Int.self))),
                      GraphQLField("multiplier", type: .nonNull(.scalar(Double.self))),
                      GraphQLField("constant", type: .nonNull(.scalar(Double.self))),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(startByte: Int, endByte: Int, numberOfSensors: Int, bytesPerSensors: Int, startSensorsCount: Int, endSensorsCount: Int, bytesPaddedBetweenSensors: Int, multiplier: Double, constant: Double) {
                    self.init(unsafeResultMap: ["__typename": "PackTemperatureChallengeResponse", "startByte": startByte, "endByte": endByte, "numberOfSensors": numberOfSensors, "bytesPerSensors": bytesPerSensors, "startSensorsCount": startSensorsCount, "endSensorsCount": endSensorsCount, "bytesPaddedBetweenSensors": bytesPaddedBetweenSensors, "multiplier": multiplier, "constant": constant])
                  }

                  public var __typename: String {
                    get {
                      return resultMap["__typename"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  /// The first byte of relevant data
                  public var startByte: Int {
                    get {
                      return resultMap["startByte"]! as! Int
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "startByte")
                    }
                  }

                  /// The last byte of relevant data
                  public var endByte: Int {
                    get {
                      return resultMap["endByte"]! as! Int
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "endByte")
                    }
                  }

                  /// Number of individual battery cells
                  public var numberOfSensors: Int {
                    get {
                      return resultMap["numberOfSensors"]! as! Int
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "numberOfSensors")
                    }
                  }

                  /// Number of bytes used to store individual battery cell value
                  public var bytesPerSensors: Int {
                    get {
                      return resultMap["bytesPerSensors"]! as! Int
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "bytesPerSensors")
                    }
                  }

                  /// Starting number of cells
                  public var startSensorsCount: Int {
                    get {
                      return resultMap["startSensorsCount"]! as! Int
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "startSensorsCount")
                    }
                  }

                  /// Ending number of cells
                  public var endSensorsCount: Int {
                    get {
                      return resultMap["endSensorsCount"]! as! Int
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "endSensorsCount")
                    }
                  }

                  /// Number of padded bytes between each cell
                  /// Most likely zero.
                  public var bytesPaddedBetweenSensors: Int {
                    get {
                      return resultMap["bytesPaddedBetweenSensors"]! as! Int
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "bytesPaddedBetweenSensors")
                    }
                  }

                  /// multiplier to apply to bytes hex value.
                  /// hexToDec(Bytes Value) * multiplier + constant = Human Readable value
                  public var multiplier: Double {
                    get {
                      return resultMap["multiplier"]! as! Double
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "multiplier")
                    }
                  }

                  /// constant to add to bytes hex value.
                  /// hexToDec(Bytes Value) * multiplier + constant = Human Readable value
                  public var constant: Double {
                    get {
                      return resultMap["constant"]! as! Double
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "constant")
                    }
                  }
                }

                public struct Validation: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["ChallengeValidation"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("numberOfFrames", type: .nonNull(.scalar(Int.self))),
                      GraphQLField("lowerBounds", type: .nonNull(.scalar(Double.self))),
                      GraphQLField("upperBounds", type: .nonNull(.scalar(Double.self))),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(numberOfFrames: Int, lowerBounds: Double, upperBounds: Double) {
                    self.init(unsafeResultMap: ["__typename": "ChallengeValidation", "numberOfFrames": numberOfFrames, "lowerBounds": lowerBounds, "upperBounds": upperBounds])
                  }

                  public var __typename: String {
                    get {
                      return resultMap["__typename"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  /// number of expected frames
                  public var numberOfFrames: Int {
                    get {
                      return resultMap["numberOfFrames"]! as! Int
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "numberOfFrames")
                    }
                  }

                  /// Lowest possible value after applying multiplier + constant
                  public var lowerBounds: Double {
                    get {
                      return resultMap["lowerBounds"]! as! Double
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "lowerBounds")
                    }
                  }

                  /// Highest possible value after applying multiplier + constant
                  public var upperBounds: Double {
                    get {
                      return resultMap["upperBounds"]! as! Double
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "upperBounds")
                    }
                  }
                }
              }

              public struct PackVoltage: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["PackChallengeInstruction"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("challenge", type: .nonNull(.object(Challenge.selections))),
                    GraphQLField("response", type: .nonNull(.object(Response.selections))),
                    GraphQLField("validation", type: .nonNull(.object(Validation.selections))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(challenge: Challenge, response: Response, validation: Validation) {
                  self.init(unsafeResultMap: ["__typename": "PackChallengeInstruction", "challenge": challenge.resultMap, "response": response.resultMap, "validation": validation.resultMap])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                public var challenge: Challenge {
                  get {
                    return Challenge(unsafeResultMap: resultMap["challenge"]! as! ResultMap)
                  }
                  set {
                    resultMap.updateValue(newValue.resultMap, forKey: "challenge")
                  }
                }

                public var response: Response {
                  get {
                    return Response(unsafeResultMap: resultMap["response"]! as! ResultMap)
                  }
                  set {
                    resultMap.updateValue(newValue.resultMap, forKey: "response")
                  }
                }

                public var validation: Validation {
                  get {
                    return Validation(unsafeResultMap: resultMap["validation"]! as! ResultMap)
                  }
                  set {
                    resultMap.updateValue(newValue.resultMap, forKey: "validation")
                  }
                }

                public struct Challenge: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["Challenge"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("canFilter", type: .scalar(String.self)),
                      GraphQLField("canMask", type: .scalar(String.self)),
                      GraphQLField("header", type: .nonNull(.scalar(String.self))),
                      GraphQLField("pid", type: .nonNull(.scalar(String.self))),
                      GraphQLField("flowControl", type: .object(FlowControl.selections)),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(canFilter: String? = nil, canMask: String? = nil, header: String, pid: String, flowControl: FlowControl? = nil) {
                    self.init(unsafeResultMap: ["__typename": "Challenge", "canFilter": canFilter, "canMask": canMask, "header": header, "pid": pid, "flowControl": flowControl.flatMap { (value: FlowControl) -> ResultMap in value.resultMap }])
                  }

                  public var __typename: String {
                    get {
                      return resultMap["__typename"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  public var canFilter: String? {
                    get {
                      return resultMap["canFilter"] as? String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "canFilter")
                    }
                  }

                  public var canMask: String? {
                    get {
                      return resultMap["canMask"] as? String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "canMask")
                    }
                  }

                  public var header: String {
                    get {
                      return resultMap["header"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "header")
                    }
                  }

                  /// OBD-II PIDs; 8 bytes of data in hex. (Pad right if you not provided)
                  public var pid: String {
                    get {
                      return resultMap["pid"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "pid")
                    }
                  }

                  public var flowControl: FlowControl? {
                    get {
                      return (resultMap["flowControl"] as? ResultMap).flatMap { FlowControl(unsafeResultMap: $0) }
                    }
                    set {
                      resultMap.updateValue(newValue?.resultMap, forKey: "flowControl")
                    }
                  }

                  public struct FlowControl: GraphQLSelectionSet {
                    public static let possibleTypes: [String] = ["FlowControl"]

                    public static var selections: [GraphQLSelection] {
                      return [
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("flowControlHeader", type: .nonNull(.scalar(String.self))),
                        GraphQLField("flowControlData", type: .nonNull(.scalar(String.self))),
                      ]
                    }

                    public private(set) var resultMap: ResultMap

                    public init(unsafeResultMap: ResultMap) {
                      self.resultMap = unsafeResultMap
                    }

                    public init(flowControlHeader: String, flowControlData: String) {
                      self.init(unsafeResultMap: ["__typename": "FlowControl", "flowControlHeader": flowControlHeader, "flowControlData": flowControlData])
                    }

                    public var __typename: String {
                      get {
                        return resultMap["__typename"]! as! String
                      }
                      set {
                        resultMap.updateValue(newValue, forKey: "__typename")
                      }
                    }

                    public var flowControlHeader: String {
                      get {
                        return resultMap["flowControlHeader"]! as! String
                      }
                      set {
                        resultMap.updateValue(newValue, forKey: "flowControlHeader")
                      }
                    }

                    public var flowControlData: String {
                      get {
                        return resultMap["flowControlData"]! as! String
                      }
                      set {
                        resultMap.updateValue(newValue, forKey: "flowControlData")
                      }
                    }
                  }
                }

                public struct Response: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["ChallengeResponse"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("startByte", type: .nonNull(.scalar(Int.self))),
                      GraphQLField("endByte", type: .nonNull(.scalar(Int.self))),
                      GraphQLField("multiplier", type: .nonNull(.scalar(Double.self))),
                      GraphQLField("constant", type: .nonNull(.scalar(Double.self))),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(startByte: Int, endByte: Int, multiplier: Double, constant: Double) {
                    self.init(unsafeResultMap: ["__typename": "ChallengeResponse", "startByte": startByte, "endByte": endByte, "multiplier": multiplier, "constant": constant])
                  }

                  public var __typename: String {
                    get {
                      return resultMap["__typename"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  /// The first byte of relevant data
                  public var startByte: Int {
                    get {
                      return resultMap["startByte"]! as! Int
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "startByte")
                    }
                  }

                  /// The last byte of relevant data
                  public var endByte: Int {
                    get {
                      return resultMap["endByte"]! as! Int
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "endByte")
                    }
                  }

                  /// multiplier to apply to bytes hex value.
                  /// hexToDec(Bytes Value) * multiplier + constant = Human Readable value
                  public var multiplier: Double {
                    get {
                      return resultMap["multiplier"]! as! Double
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "multiplier")
                    }
                  }

                  /// constant to add to bytes hex value.
                  /// hexToDec(Bytes Value) * multiplier + constant = Human Readable value
                  public var constant: Double {
                    get {
                      return resultMap["constant"]! as! Double
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "constant")
                    }
                  }
                }

                public struct Validation: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["ChallengeValidation"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("upperBounds", type: .nonNull(.scalar(Double.self))),
                      GraphQLField("lowerBounds", type: .nonNull(.scalar(Double.self))),
                      GraphQLField("numberOfFrames", type: .nonNull(.scalar(Int.self))),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(upperBounds: Double, lowerBounds: Double, numberOfFrames: Int) {
                    self.init(unsafeResultMap: ["__typename": "ChallengeValidation", "upperBounds": upperBounds, "lowerBounds": lowerBounds, "numberOfFrames": numberOfFrames])
                  }

                  public var __typename: String {
                    get {
                      return resultMap["__typename"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  /// Highest possible value after applying multiplier + constant
                  public var upperBounds: Double {
                    get {
                      return resultMap["upperBounds"]! as! Double
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "upperBounds")
                    }
                  }

                  /// Lowest possible value after applying multiplier + constant
                  public var lowerBounds: Double {
                    get {
                      return resultMap["lowerBounds"]! as! Double
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "lowerBounds")
                    }
                  }

                  /// number of expected frames
                  public var numberOfFrames: Int {
                    get {
                      return resultMap["numberOfFrames"]! as! Int
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "numberOfFrames")
                    }
                  }
                }
              }

              public struct PackCurrent: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["PackChallengeInstruction"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("challenge", type: .nonNull(.object(Challenge.selections))),
                    GraphQLField("response", type: .nonNull(.object(Response.selections))),
                    GraphQLField("validation", type: .nonNull(.object(Validation.selections))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(challenge: Challenge, response: Response, validation: Validation) {
                  self.init(unsafeResultMap: ["__typename": "PackChallengeInstruction", "challenge": challenge.resultMap, "response": response.resultMap, "validation": validation.resultMap])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                public var challenge: Challenge {
                  get {
                    return Challenge(unsafeResultMap: resultMap["challenge"]! as! ResultMap)
                  }
                  set {
                    resultMap.updateValue(newValue.resultMap, forKey: "challenge")
                  }
                }

                public var response: Response {
                  get {
                    return Response(unsafeResultMap: resultMap["response"]! as! ResultMap)
                  }
                  set {
                    resultMap.updateValue(newValue.resultMap, forKey: "response")
                  }
                }

                public var validation: Validation {
                  get {
                    return Validation(unsafeResultMap: resultMap["validation"]! as! ResultMap)
                  }
                  set {
                    resultMap.updateValue(newValue.resultMap, forKey: "validation")
                  }
                }

                public struct Challenge: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["Challenge"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("canFilter", type: .scalar(String.self)),
                      GraphQLField("canMask", type: .scalar(String.self)),
                      GraphQLField("header", type: .nonNull(.scalar(String.self))),
                      GraphQLField("pid", type: .nonNull(.scalar(String.self))),
                      GraphQLField("flowControl", type: .object(FlowControl.selections)),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(canFilter: String? = nil, canMask: String? = nil, header: String, pid: String, flowControl: FlowControl? = nil) {
                    self.init(unsafeResultMap: ["__typename": "Challenge", "canFilter": canFilter, "canMask": canMask, "header": header, "pid": pid, "flowControl": flowControl.flatMap { (value: FlowControl) -> ResultMap in value.resultMap }])
                  }

                  public var __typename: String {
                    get {
                      return resultMap["__typename"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  public var canFilter: String? {
                    get {
                      return resultMap["canFilter"] as? String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "canFilter")
                    }
                  }

                  public var canMask: String? {
                    get {
                      return resultMap["canMask"] as? String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "canMask")
                    }
                  }

                  public var header: String {
                    get {
                      return resultMap["header"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "header")
                    }
                  }

                  /// OBD-II PIDs; 8 bytes of data in hex. (Pad right if you not provided)
                  public var pid: String {
                    get {
                      return resultMap["pid"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "pid")
                    }
                  }

                  public var flowControl: FlowControl? {
                    get {
                      return (resultMap["flowControl"] as? ResultMap).flatMap { FlowControl(unsafeResultMap: $0) }
                    }
                    set {
                      resultMap.updateValue(newValue?.resultMap, forKey: "flowControl")
                    }
                  }

                  public struct FlowControl: GraphQLSelectionSet {
                    public static let possibleTypes: [String] = ["FlowControl"]

                    public static var selections: [GraphQLSelection] {
                      return [
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("flowControlHeader", type: .nonNull(.scalar(String.self))),
                        GraphQLField("flowControlData", type: .nonNull(.scalar(String.self))),
                      ]
                    }

                    public private(set) var resultMap: ResultMap

                    public init(unsafeResultMap: ResultMap) {
                      self.resultMap = unsafeResultMap
                    }

                    public init(flowControlHeader: String, flowControlData: String) {
                      self.init(unsafeResultMap: ["__typename": "FlowControl", "flowControlHeader": flowControlHeader, "flowControlData": flowControlData])
                    }

                    public var __typename: String {
                      get {
                        return resultMap["__typename"]! as! String
                      }
                      set {
                        resultMap.updateValue(newValue, forKey: "__typename")
                      }
                    }

                    public var flowControlHeader: String {
                      get {
                        return resultMap["flowControlHeader"]! as! String
                      }
                      set {
                        resultMap.updateValue(newValue, forKey: "flowControlHeader")
                      }
                    }

                    public var flowControlData: String {
                      get {
                        return resultMap["flowControlData"]! as! String
                      }
                      set {
                        resultMap.updateValue(newValue, forKey: "flowControlData")
                      }
                    }
                  }
                }

                public struct Response: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["ChallengeResponse"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("startByte", type: .nonNull(.scalar(Int.self))),
                      GraphQLField("endByte", type: .nonNull(.scalar(Int.self))),
                      GraphQLField("multiplier", type: .nonNull(.scalar(Double.self))),
                      GraphQLField("constant", type: .nonNull(.scalar(Double.self))),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(startByte: Int, endByte: Int, multiplier: Double, constant: Double) {
                    self.init(unsafeResultMap: ["__typename": "ChallengeResponse", "startByte": startByte, "endByte": endByte, "multiplier": multiplier, "constant": constant])
                  }

                  public var __typename: String {
                    get {
                      return resultMap["__typename"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  /// The first byte of relevant data
                  public var startByte: Int {
                    get {
                      return resultMap["startByte"]! as! Int
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "startByte")
                    }
                  }

                  /// The last byte of relevant data
                  public var endByte: Int {
                    get {
                      return resultMap["endByte"]! as! Int
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "endByte")
                    }
                  }

                  /// multiplier to apply to bytes hex value.
                  /// hexToDec(Bytes Value) * multiplier + constant = Human Readable value
                  public var multiplier: Double {
                    get {
                      return resultMap["multiplier"]! as! Double
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "multiplier")
                    }
                  }

                  /// constant to add to bytes hex value.
                  /// hexToDec(Bytes Value) * multiplier + constant = Human Readable value
                  public var constant: Double {
                    get {
                      return resultMap["constant"]! as! Double
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "constant")
                    }
                  }
                }

                public struct Validation: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["ChallengeValidation"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("numberOfFrames", type: .nonNull(.scalar(Int.self))),
                      GraphQLField("lowerBounds", type: .nonNull(.scalar(Double.self))),
                      GraphQLField("upperBounds", type: .nonNull(.scalar(Double.self))),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(numberOfFrames: Int, lowerBounds: Double, upperBounds: Double) {
                    self.init(unsafeResultMap: ["__typename": "ChallengeValidation", "numberOfFrames": numberOfFrames, "lowerBounds": lowerBounds, "upperBounds": upperBounds])
                  }

                  public var __typename: String {
                    get {
                      return resultMap["__typename"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  /// number of expected frames
                  public var numberOfFrames: Int {
                    get {
                      return resultMap["numberOfFrames"]! as! Int
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "numberOfFrames")
                    }
                  }

                  /// Lowest possible value after applying multiplier + constant
                  public var lowerBounds: Double {
                    get {
                      return resultMap["lowerBounds"]! as! Double
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "lowerBounds")
                    }
                  }

                  /// Highest possible value after applying multiplier + constant
                  public var upperBounds: Double {
                    get {
                      return resultMap["upperBounds"]! as! Double
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "upperBounds")
                    }
                  }
                }
              }

              public struct CellVoltage: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["CellVoltageChallengeInstruction"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("challenge", type: .nonNull(.object(Challenge.selections))),
                    GraphQLField("response", type: .nonNull(.object(Response.selections))),
                    GraphQLField("validation", type: .nonNull(.object(Validation.selections))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(challenge: Challenge, response: Response, validation: Validation) {
                  self.init(unsafeResultMap: ["__typename": "CellVoltageChallengeInstruction", "challenge": challenge.resultMap, "response": response.resultMap, "validation": validation.resultMap])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                public var challenge: Challenge {
                  get {
                    return Challenge(unsafeResultMap: resultMap["challenge"]! as! ResultMap)
                  }
                  set {
                    resultMap.updateValue(newValue.resultMap, forKey: "challenge")
                  }
                }

                public var response: Response {
                  get {
                    return Response(unsafeResultMap: resultMap["response"]! as! ResultMap)
                  }
                  set {
                    resultMap.updateValue(newValue.resultMap, forKey: "response")
                  }
                }

                public var validation: Validation {
                  get {
                    return Validation(unsafeResultMap: resultMap["validation"]! as! ResultMap)
                  }
                  set {
                    resultMap.updateValue(newValue.resultMap, forKey: "validation")
                  }
                }

                public struct Challenge: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["Challenge"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("canFilter", type: .scalar(String.self)),
                      GraphQLField("canMask", type: .scalar(String.self)),
                      GraphQLField("header", type: .nonNull(.scalar(String.self))),
                      GraphQLField("pid", type: .nonNull(.scalar(String.self))),
                      GraphQLField("flowControl", type: .object(FlowControl.selections)),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(canFilter: String? = nil, canMask: String? = nil, header: String, pid: String, flowControl: FlowControl? = nil) {
                    self.init(unsafeResultMap: ["__typename": "Challenge", "canFilter": canFilter, "canMask": canMask, "header": header, "pid": pid, "flowControl": flowControl.flatMap { (value: FlowControl) -> ResultMap in value.resultMap }])
                  }

                  public var __typename: String {
                    get {
                      return resultMap["__typename"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  public var canFilter: String? {
                    get {
                      return resultMap["canFilter"] as? String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "canFilter")
                    }
                  }

                  public var canMask: String? {
                    get {
                      return resultMap["canMask"] as? String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "canMask")
                    }
                  }

                  public var header: String {
                    get {
                      return resultMap["header"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "header")
                    }
                  }

                  /// OBD-II PIDs; 8 bytes of data in hex. (Pad right if you not provided)
                  public var pid: String {
                    get {
                      return resultMap["pid"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "pid")
                    }
                  }

                  public var flowControl: FlowControl? {
                    get {
                      return (resultMap["flowControl"] as? ResultMap).flatMap { FlowControl(unsafeResultMap: $0) }
                    }
                    set {
                      resultMap.updateValue(newValue?.resultMap, forKey: "flowControl")
                    }
                  }

                  public struct FlowControl: GraphQLSelectionSet {
                    public static let possibleTypes: [String] = ["FlowControl"]

                    public static var selections: [GraphQLSelection] {
                      return [
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("flowControlHeader", type: .nonNull(.scalar(String.self))),
                        GraphQLField("flowControlData", type: .nonNull(.scalar(String.self))),
                      ]
                    }

                    public private(set) var resultMap: ResultMap

                    public init(unsafeResultMap: ResultMap) {
                      self.resultMap = unsafeResultMap
                    }

                    public init(flowControlHeader: String, flowControlData: String) {
                      self.init(unsafeResultMap: ["__typename": "FlowControl", "flowControlHeader": flowControlHeader, "flowControlData": flowControlData])
                    }

                    public var __typename: String {
                      get {
                        return resultMap["__typename"]! as! String
                      }
                      set {
                        resultMap.updateValue(newValue, forKey: "__typename")
                      }
                    }

                    public var flowControlHeader: String {
                      get {
                        return resultMap["flowControlHeader"]! as! String
                      }
                      set {
                        resultMap.updateValue(newValue, forKey: "flowControlHeader")
                      }
                    }

                    public var flowControlData: String {
                      get {
                        return resultMap["flowControlData"]! as! String
                      }
                      set {
                        resultMap.updateValue(newValue, forKey: "flowControlData")
                      }
                    }
                  }
                }

                public struct Response: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["CellVoltageChallengeResponse"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("startByte", type: .nonNull(.scalar(Int.self))),
                      GraphQLField("endByte", type: .nonNull(.scalar(Int.self))),
                      GraphQLField("numberOfCells", type: .nonNull(.scalar(Int.self))),
                      GraphQLField("bytesPerCell", type: .nonNull(.scalar(Int.self))),
                      GraphQLField("startCellCount", type: .nonNull(.scalar(Int.self))),
                      GraphQLField("endCellCount", type: .nonNull(.scalar(Int.self))),
                      GraphQLField("bytesPaddedBetweenCells", type: .nonNull(.scalar(Int.self))),
                      GraphQLField("multiplier", type: .nonNull(.scalar(Double.self))),
                      GraphQLField("constant", type: .nonNull(.scalar(Double.self))),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(startByte: Int, endByte: Int, numberOfCells: Int, bytesPerCell: Int, startCellCount: Int, endCellCount: Int, bytesPaddedBetweenCells: Int, multiplier: Double, constant: Double) {
                    self.init(unsafeResultMap: ["__typename": "CellVoltageChallengeResponse", "startByte": startByte, "endByte": endByte, "numberOfCells": numberOfCells, "bytesPerCell": bytesPerCell, "startCellCount": startCellCount, "endCellCount": endCellCount, "bytesPaddedBetweenCells": bytesPaddedBetweenCells, "multiplier": multiplier, "constant": constant])
                  }

                  public var __typename: String {
                    get {
                      return resultMap["__typename"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  /// The first byte of relevant data
                  public var startByte: Int {
                    get {
                      return resultMap["startByte"]! as! Int
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "startByte")
                    }
                  }

                  /// The last byte of relevant data
                  public var endByte: Int {
                    get {
                      return resultMap["endByte"]! as! Int
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "endByte")
                    }
                  }

                  /// Number of individual battery cells
                  public var numberOfCells: Int {
                    get {
                      return resultMap["numberOfCells"]! as! Int
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "numberOfCells")
                    }
                  }

                  /// Number of bytes used to store individual battery cell value
                  public var bytesPerCell: Int {
                    get {
                      return resultMap["bytesPerCell"]! as! Int
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "bytesPerCell")
                    }
                  }

                  /// Starting number of cells
                  public var startCellCount: Int {
                    get {
                      return resultMap["startCellCount"]! as! Int
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "startCellCount")
                    }
                  }

                  /// Ending number of cells
                  public var endCellCount: Int {
                    get {
                      return resultMap["endCellCount"]! as! Int
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "endCellCount")
                    }
                  }

                  /// Number of padded bytes between each cell
                  /// Most likely zero.
                  public var bytesPaddedBetweenCells: Int {
                    get {
                      return resultMap["bytesPaddedBetweenCells"]! as! Int
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "bytesPaddedBetweenCells")
                    }
                  }

                  /// multiplier to apply to bytes hex value.
                  /// hexToDec(Bytes Value) * multiplier + constant = Human Readable value
                  public var multiplier: Double {
                    get {
                      return resultMap["multiplier"]! as! Double
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "multiplier")
                    }
                  }

                  /// constant to add to bytes hex value.
                  /// hexToDec(Bytes Value) * multiplier + constant = Human Readable value
                  public var constant: Double {
                    get {
                      return resultMap["constant"]! as! Double
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "constant")
                    }
                  }
                }

                public struct Validation: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["ChallengeValidation"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("lowerBounds", type: .nonNull(.scalar(Double.self))),
                      GraphQLField("upperBounds", type: .nonNull(.scalar(Double.self))),
                      GraphQLField("numberOfFrames", type: .nonNull(.scalar(Int.self))),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(lowerBounds: Double, upperBounds: Double, numberOfFrames: Int) {
                    self.init(unsafeResultMap: ["__typename": "ChallengeValidation", "lowerBounds": lowerBounds, "upperBounds": upperBounds, "numberOfFrames": numberOfFrames])
                  }

                  public var __typename: String {
                    get {
                      return resultMap["__typename"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  /// Lowest possible value after applying multiplier + constant
                  public var lowerBounds: Double {
                    get {
                      return resultMap["lowerBounds"]! as! Double
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "lowerBounds")
                    }
                  }

                  /// Highest possible value after applying multiplier + constant
                  public var upperBounds: Double {
                    get {
                      return resultMap["upperBounds"]! as! Double
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "upperBounds")
                    }
                  }

                  /// number of expected frames
                  public var numberOfFrames: Int {
                    get {
                      return resultMap["numberOfFrames"]! as! Int
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "numberOfFrames")
                    }
                  }
                }
              }
            }

            public struct BatteryAge: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["ChallengeInstruction"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("protocol", type: .nonNull(.object(`Protocol`.selections))),
                  GraphQLField("challenge", type: .nonNull(.object(Challenge.selections))),
                  GraphQLField("response", type: .nonNull(.object(Response.selections))),
                  GraphQLField("validation", type: .nonNull(.object(Validation.selections))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(`protocol`: `Protocol`, challenge: Challenge, response: Response, validation: Validation) {
                self.init(unsafeResultMap: ["__typename": "ChallengeInstruction", "protocol": `protocol`.resultMap, "challenge": challenge.resultMap, "response": response.resultMap, "validation": validation.resultMap])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var `protocol`: `Protocol` {
                get {
                  return `Protocol`(unsafeResultMap: resultMap["protocol"]! as! ResultMap)
                }
                set {
                  resultMap.updateValue(newValue.resultMap, forKey: "protocol")
                }
              }

              public var challenge: Challenge {
                get {
                  return Challenge(unsafeResultMap: resultMap["challenge"]! as! ResultMap)
                }
                set {
                  resultMap.updateValue(newValue.resultMap, forKey: "challenge")
                }
              }

              public var response: Response {
                get {
                  return Response(unsafeResultMap: resultMap["response"]! as! ResultMap)
                }
                set {
                  resultMap.updateValue(newValue.resultMap, forKey: "response")
                }
              }

              public var validation: Validation {
                get {
                  return Validation(unsafeResultMap: resultMap["validation"]! as! ResultMap)
                }
                set {
                  resultMap.updateValue(newValue.resultMap, forKey: "validation")
                }
              }

              public struct `Protocol`: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["OBD2Protocol"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("elm327ProtocolPreset", type: .scalar(ELM327ProtocolPreset.self)),
                    GraphQLField("obdLinkProtocolPreset", type: .scalar(OBDLinkProtocolPreset.self)),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(elm327ProtocolPreset: ELM327ProtocolPreset? = nil, obdLinkProtocolPreset: OBDLinkProtocolPreset? = nil) {
                  self.init(unsafeResultMap: ["__typename": "OBD2Protocol", "elm327ProtocolPreset": elm327ProtocolPreset, "obdLinkProtocolPreset": obdLinkProtocolPreset])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// elm327ProtocolPreset will be null if obdLinkProtocolPreset doesn't map to elm327ProtocolPreset ENUM
                public var elm327ProtocolPreset: ELM327ProtocolPreset? {
                  get {
                    return resultMap["elm327ProtocolPreset"] as? ELM327ProtocolPreset
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "elm327ProtocolPreset")
                  }
                }

                /// obdLinkProtocolPreset will be null if options is provided upon on creation
                public var obdLinkProtocolPreset: OBDLinkProtocolPreset? {
                  get {
                    return resultMap["obdLinkProtocolPreset"] as? OBDLinkProtocolPreset
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "obdLinkProtocolPreset")
                  }
                }
              }

              public struct Challenge: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Challenge"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("canFilter", type: .scalar(String.self)),
                    GraphQLField("canMask", type: .scalar(String.self)),
                    GraphQLField("header", type: .nonNull(.scalar(String.self))),
                    GraphQLField("pid", type: .nonNull(.scalar(String.self))),
                    GraphQLField("flowControl", type: .object(FlowControl.selections)),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(canFilter: String? = nil, canMask: String? = nil, header: String, pid: String, flowControl: FlowControl? = nil) {
                  self.init(unsafeResultMap: ["__typename": "Challenge", "canFilter": canFilter, "canMask": canMask, "header": header, "pid": pid, "flowControl": flowControl.flatMap { (value: FlowControl) -> ResultMap in value.resultMap }])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                public var canFilter: String? {
                  get {
                    return resultMap["canFilter"] as? String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "canFilter")
                  }
                }

                public var canMask: String? {
                  get {
                    return resultMap["canMask"] as? String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "canMask")
                  }
                }

                public var header: String {
                  get {
                    return resultMap["header"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "header")
                  }
                }

                /// OBD-II PIDs; 8 bytes of data in hex. (Pad right if you not provided)
                public var pid: String {
                  get {
                    return resultMap["pid"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "pid")
                  }
                }

                public var flowControl: FlowControl? {
                  get {
                    return (resultMap["flowControl"] as? ResultMap).flatMap { FlowControl(unsafeResultMap: $0) }
                  }
                  set {
                    resultMap.updateValue(newValue?.resultMap, forKey: "flowControl")
                  }
                }

                public struct FlowControl: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["FlowControl"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("flowControlHeader", type: .nonNull(.scalar(String.self))),
                      GraphQLField("flowControlData", type: .nonNull(.scalar(String.self))),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(flowControlHeader: String, flowControlData: String) {
                    self.init(unsafeResultMap: ["__typename": "FlowControl", "flowControlHeader": flowControlHeader, "flowControlData": flowControlData])
                  }

                  public var __typename: String {
                    get {
                      return resultMap["__typename"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  public var flowControlHeader: String {
                    get {
                      return resultMap["flowControlHeader"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "flowControlHeader")
                    }
                  }

                  public var flowControlData: String {
                    get {
                      return resultMap["flowControlData"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "flowControlData")
                    }
                  }
                }
              }

              public struct Response: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["ChallengeResponse"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("startByte", type: .nonNull(.scalar(Int.self))),
                    GraphQLField("endByte", type: .nonNull(.scalar(Int.self))),
                    GraphQLField("multiplier", type: .nonNull(.scalar(Double.self))),
                    GraphQLField("constant", type: .nonNull(.scalar(Double.self))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(startByte: Int, endByte: Int, multiplier: Double, constant: Double) {
                  self.init(unsafeResultMap: ["__typename": "ChallengeResponse", "startByte": startByte, "endByte": endByte, "multiplier": multiplier, "constant": constant])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// The first byte of relevant data
                public var startByte: Int {
                  get {
                    return resultMap["startByte"]! as! Int
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "startByte")
                  }
                }

                /// The last byte of relevant data
                public var endByte: Int {
                  get {
                    return resultMap["endByte"]! as! Int
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "endByte")
                  }
                }

                /// multiplier to apply to bytes hex value.
                /// hexToDec(Bytes Value) * multiplier + constant = Human Readable value
                public var multiplier: Double {
                  get {
                    return resultMap["multiplier"]! as! Double
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "multiplier")
                  }
                }

                /// constant to add to bytes hex value.
                /// hexToDec(Bytes Value) * multiplier + constant = Human Readable value
                public var constant: Double {
                  get {
                    return resultMap["constant"]! as! Double
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "constant")
                  }
                }
              }

              public struct Validation: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["ChallengeValidation"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("numberOfFrames", type: .nonNull(.scalar(Int.self))),
                    GraphQLField("lowerBounds", type: .nonNull(.scalar(Double.self))),
                    GraphQLField("upperBounds", type: .nonNull(.scalar(Double.self))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(numberOfFrames: Int, lowerBounds: Double, upperBounds: Double) {
                  self.init(unsafeResultMap: ["__typename": "ChallengeValidation", "numberOfFrames": numberOfFrames, "lowerBounds": lowerBounds, "upperBounds": upperBounds])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// number of expected frames
                public var numberOfFrames: Int {
                  get {
                    return resultMap["numberOfFrames"]! as! Int
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "numberOfFrames")
                  }
                }

                /// Lowest possible value after applying multiplier + constant
                public var lowerBounds: Double {
                  get {
                    return resultMap["lowerBounds"]! as! Double
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "lowerBounds")
                  }
                }

                /// Highest possible value after applying multiplier + constant
                public var upperBounds: Double {
                  get {
                    return resultMap["upperBounds"]! as! Double
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "upperBounds")
                  }
                }
              }
            }

            public struct DiagnosticSession: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["DiagnosticInstruction"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("protocol", type: .nonNull(.object(`Protocol`.selections))),
                  GraphQLField("challenge", type: .object(Challenge.selections)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(`protocol`: `Protocol`, challenge: Challenge? = nil) {
                self.init(unsafeResultMap: ["__typename": "DiagnosticInstruction", "protocol": `protocol`.resultMap, "challenge": challenge.flatMap { (value: Challenge) -> ResultMap in value.resultMap }])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var `protocol`: `Protocol` {
                get {
                  return `Protocol`(unsafeResultMap: resultMap["protocol"]! as! ResultMap)
                }
                set {
                  resultMap.updateValue(newValue.resultMap, forKey: "protocol")
                }
              }

              /// Challenge is nullable for Diagnostic, Can Filters and Masks added to Diagnostic Mode Challenges
              public var challenge: Challenge? {
                get {
                  return (resultMap["challenge"] as? ResultMap).flatMap { Challenge(unsafeResultMap: $0) }
                }
                set {
                  resultMap.updateValue(newValue?.resultMap, forKey: "challenge")
                }
              }

              public struct `Protocol`: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["OBD2Protocol"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("elm327ProtocolPreset", type: .scalar(ELM327ProtocolPreset.self)),
                    GraphQLField("obdLinkProtocolPreset", type: .scalar(OBDLinkProtocolPreset.self)),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(elm327ProtocolPreset: ELM327ProtocolPreset? = nil, obdLinkProtocolPreset: OBDLinkProtocolPreset? = nil) {
                  self.init(unsafeResultMap: ["__typename": "OBD2Protocol", "elm327ProtocolPreset": elm327ProtocolPreset, "obdLinkProtocolPreset": obdLinkProtocolPreset])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                /// elm327ProtocolPreset will be null if obdLinkProtocolPreset doesn't map to elm327ProtocolPreset ENUM
                public var elm327ProtocolPreset: ELM327ProtocolPreset? {
                  get {
                    return resultMap["elm327ProtocolPreset"] as? ELM327ProtocolPreset
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "elm327ProtocolPreset")
                  }
                }

                /// obdLinkProtocolPreset will be null if options is provided upon on creation
                public var obdLinkProtocolPreset: OBDLinkProtocolPreset? {
                  get {
                    return resultMap["obdLinkProtocolPreset"] as? OBDLinkProtocolPreset
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "obdLinkProtocolPreset")
                  }
                }
              }

              public struct Challenge: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["Challenge"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("canFilter", type: .scalar(String.self)),
                    GraphQLField("canMask", type: .scalar(String.self)),
                    GraphQLField("header", type: .nonNull(.scalar(String.self))),
                    GraphQLField("pid", type: .nonNull(.scalar(String.self))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(canFilter: String? = nil, canMask: String? = nil, header: String, pid: String) {
                  self.init(unsafeResultMap: ["__typename": "Challenge", "canFilter": canFilter, "canMask": canMask, "header": header, "pid": pid])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                public var canFilter: String? {
                  get {
                    return resultMap["canFilter"] as? String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "canFilter")
                  }
                }

                public var canMask: String? {
                  get {
                    return resultMap["canMask"] as? String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "canMask")
                  }
                }

                public var header: String {
                  get {
                    return resultMap["header"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "header")
                  }
                }

                /// OBD-II PIDs; 8 bytes of data in hex. (Pad right if you not provided)
                public var pid: String {
                  get {
                    return resultMap["pid"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "pid")
                  }
                }
              }
            }

            public struct MiscCommand: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["MiscChallengeInstruction"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("label", type: .nonNull(.scalar(String.self))),
                  GraphQLField("instruction", type: .object(Instruction.selections)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(label: String, instruction: Instruction? = nil) {
                self.init(unsafeResultMap: ["__typename": "MiscChallengeInstruction", "label": label, "instruction": instruction.flatMap { (value: Instruction) -> ResultMap in value.resultMap }])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              public var label: String {
                get {
                  return resultMap["label"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "label")
                }
              }

              public var instruction: Instruction? {
                get {
                  return (resultMap["instruction"] as? ResultMap).flatMap { Instruction(unsafeResultMap: $0) }
                }
                set {
                  resultMap.updateValue(newValue?.resultMap, forKey: "instruction")
                }
              }

              public struct Instruction: GraphQLSelectionSet {
                public static let possibleTypes: [String] = ["ChallengeInstruction"]

                public static var selections: [GraphQLSelection] {
                  return [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("challenge", type: .nonNull(.object(Challenge.selections))),
                    GraphQLField("protocol", type: .nonNull(.object(`Protocol`.selections))),
                    GraphQLField("response", type: .nonNull(.object(Response.selections))),
                    GraphQLField("validation", type: .nonNull(.object(Validation.selections))),
                  ]
                }

                public private(set) var resultMap: ResultMap

                public init(unsafeResultMap: ResultMap) {
                  self.resultMap = unsafeResultMap
                }

                public init(challenge: Challenge, `protocol`: `Protocol`, response: Response, validation: Validation) {
                  self.init(unsafeResultMap: ["__typename": "ChallengeInstruction", "challenge": challenge.resultMap, "protocol": `protocol`.resultMap, "response": response.resultMap, "validation": validation.resultMap])
                }

                public var __typename: String {
                  get {
                    return resultMap["__typename"]! as! String
                  }
                  set {
                    resultMap.updateValue(newValue, forKey: "__typename")
                  }
                }

                public var challenge: Challenge {
                  get {
                    return Challenge(unsafeResultMap: resultMap["challenge"]! as! ResultMap)
                  }
                  set {
                    resultMap.updateValue(newValue.resultMap, forKey: "challenge")
                  }
                }

                public var `protocol`: `Protocol` {
                  get {
                    return `Protocol`(unsafeResultMap: resultMap["protocol"]! as! ResultMap)
                  }
                  set {
                    resultMap.updateValue(newValue.resultMap, forKey: "protocol")
                  }
                }

                public var response: Response {
                  get {
                    return Response(unsafeResultMap: resultMap["response"]! as! ResultMap)
                  }
                  set {
                    resultMap.updateValue(newValue.resultMap, forKey: "response")
                  }
                }

                public var validation: Validation {
                  get {
                    return Validation(unsafeResultMap: resultMap["validation"]! as! ResultMap)
                  }
                  set {
                    resultMap.updateValue(newValue.resultMap, forKey: "validation")
                  }
                }

                public struct Challenge: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["Challenge"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("canFilter", type: .scalar(String.self)),
                      GraphQLField("canMask", type: .scalar(String.self)),
                      GraphQLField("header", type: .nonNull(.scalar(String.self))),
                      GraphQLField("pid", type: .nonNull(.scalar(String.self))),
                      GraphQLField("flowControl", type: .object(FlowControl.selections)),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(canFilter: String? = nil, canMask: String? = nil, header: String, pid: String, flowControl: FlowControl? = nil) {
                    self.init(unsafeResultMap: ["__typename": "Challenge", "canFilter": canFilter, "canMask": canMask, "header": header, "pid": pid, "flowControl": flowControl.flatMap { (value: FlowControl) -> ResultMap in value.resultMap }])
                  }

                  public var __typename: String {
                    get {
                      return resultMap["__typename"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  public var canFilter: String? {
                    get {
                      return resultMap["canFilter"] as? String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "canFilter")
                    }
                  }

                  public var canMask: String? {
                    get {
                      return resultMap["canMask"] as? String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "canMask")
                    }
                  }

                  public var header: String {
                    get {
                      return resultMap["header"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "header")
                    }
                  }

                  /// OBD-II PIDs; 8 bytes of data in hex. (Pad right if you not provided)
                  public var pid: String {
                    get {
                      return resultMap["pid"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "pid")
                    }
                  }

                  public var flowControl: FlowControl? {
                    get {
                      return (resultMap["flowControl"] as? ResultMap).flatMap { FlowControl(unsafeResultMap: $0) }
                    }
                    set {
                      resultMap.updateValue(newValue?.resultMap, forKey: "flowControl")
                    }
                  }

                  public struct FlowControl: GraphQLSelectionSet {
                    public static let possibleTypes: [String] = ["FlowControl"]

                    public static var selections: [GraphQLSelection] {
                      return [
                        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                        GraphQLField("flowControlHeader", type: .nonNull(.scalar(String.self))),
                        GraphQLField("flowControlData", type: .nonNull(.scalar(String.self))),
                      ]
                    }

                    public private(set) var resultMap: ResultMap

                    public init(unsafeResultMap: ResultMap) {
                      self.resultMap = unsafeResultMap
                    }

                    public init(flowControlHeader: String, flowControlData: String) {
                      self.init(unsafeResultMap: ["__typename": "FlowControl", "flowControlHeader": flowControlHeader, "flowControlData": flowControlData])
                    }

                    public var __typename: String {
                      get {
                        return resultMap["__typename"]! as! String
                      }
                      set {
                        resultMap.updateValue(newValue, forKey: "__typename")
                      }
                    }

                    public var flowControlHeader: String {
                      get {
                        return resultMap["flowControlHeader"]! as! String
                      }
                      set {
                        resultMap.updateValue(newValue, forKey: "flowControlHeader")
                      }
                    }

                    public var flowControlData: String {
                      get {
                        return resultMap["flowControlData"]! as! String
                      }
                      set {
                        resultMap.updateValue(newValue, forKey: "flowControlData")
                      }
                    }
                  }
                }

                public struct `Protocol`: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["OBD2Protocol"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("elm327ProtocolPreset", type: .scalar(ELM327ProtocolPreset.self)),
                      GraphQLField("obdLinkProtocolPreset", type: .scalar(OBDLinkProtocolPreset.self)),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(elm327ProtocolPreset: ELM327ProtocolPreset? = nil, obdLinkProtocolPreset: OBDLinkProtocolPreset? = nil) {
                    self.init(unsafeResultMap: ["__typename": "OBD2Protocol", "elm327ProtocolPreset": elm327ProtocolPreset, "obdLinkProtocolPreset": obdLinkProtocolPreset])
                  }

                  public var __typename: String {
                    get {
                      return resultMap["__typename"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  /// elm327ProtocolPreset will be null if obdLinkProtocolPreset doesn't map to elm327ProtocolPreset ENUM
                  public var elm327ProtocolPreset: ELM327ProtocolPreset? {
                    get {
                      return resultMap["elm327ProtocolPreset"] as? ELM327ProtocolPreset
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "elm327ProtocolPreset")
                    }
                  }

                  /// obdLinkProtocolPreset will be null if options is provided upon on creation
                  public var obdLinkProtocolPreset: OBDLinkProtocolPreset? {
                    get {
                      return resultMap["obdLinkProtocolPreset"] as? OBDLinkProtocolPreset
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "obdLinkProtocolPreset")
                    }
                  }
                }

                public struct Response: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["ChallengeResponse"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("constant", type: .nonNull(.scalar(Double.self))),
                      GraphQLField("endByte", type: .nonNull(.scalar(Int.self))),
                      GraphQLField("multiplier", type: .nonNull(.scalar(Double.self))),
                      GraphQLField("startByte", type: .nonNull(.scalar(Int.self))),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(constant: Double, endByte: Int, multiplier: Double, startByte: Int) {
                    self.init(unsafeResultMap: ["__typename": "ChallengeResponse", "constant": constant, "endByte": endByte, "multiplier": multiplier, "startByte": startByte])
                  }

                  public var __typename: String {
                    get {
                      return resultMap["__typename"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  /// constant to add to bytes hex value.
                  /// hexToDec(Bytes Value) * multiplier + constant = Human Readable value
                  public var constant: Double {
                    get {
                      return resultMap["constant"]! as! Double
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "constant")
                    }
                  }

                  /// The last byte of relevant data
                  public var endByte: Int {
                    get {
                      return resultMap["endByte"]! as! Int
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "endByte")
                    }
                  }

                  /// multiplier to apply to bytes hex value.
                  /// hexToDec(Bytes Value) * multiplier + constant = Human Readable value
                  public var multiplier: Double {
                    get {
                      return resultMap["multiplier"]! as! Double
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "multiplier")
                    }
                  }

                  /// The first byte of relevant data
                  public var startByte: Int {
                    get {
                      return resultMap["startByte"]! as! Int
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "startByte")
                    }
                  }
                }

                public struct Validation: GraphQLSelectionSet {
                  public static let possibleTypes: [String] = ["ChallengeValidation"]

                  public static var selections: [GraphQLSelection] {
                    return [
                      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                      GraphQLField("numberOfFrames", type: .nonNull(.scalar(Int.self))),
                      GraphQLField("upperBounds", type: .nonNull(.scalar(Double.self))),
                      GraphQLField("lowerBounds", type: .nonNull(.scalar(Double.self))),
                    ]
                  }

                  public private(set) var resultMap: ResultMap

                  public init(unsafeResultMap: ResultMap) {
                    self.resultMap = unsafeResultMap
                  }

                  public init(numberOfFrames: Int, upperBounds: Double, lowerBounds: Double) {
                    self.init(unsafeResultMap: ["__typename": "ChallengeValidation", "numberOfFrames": numberOfFrames, "upperBounds": upperBounds, "lowerBounds": lowerBounds])
                  }

                  public var __typename: String {
                    get {
                      return resultMap["__typename"]! as! String
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "__typename")
                    }
                  }

                  /// number of expected frames
                  public var numberOfFrames: Int {
                    get {
                      return resultMap["numberOfFrames"]! as! Int
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "numberOfFrames")
                    }
                  }

                  /// Highest possible value after applying multiplier + constant
                  public var upperBounds: Double {
                    get {
                      return resultMap["upperBounds"]! as! Double
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "upperBounds")
                    }
                  }

                  /// Lowest possible value after applying multiplier + constant
                  public var lowerBounds: Double {
                    get {
                      return resultMap["lowerBounds"]! as! Double
                    }
                    set {
                      resultMap.updateValue(newValue, forKey: "lowerBounds")
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

public final class GetS3PreSingedUrlQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query getS3PreSingedURL($vin: String!) {
      getS3PreSingedURL(vin: $vin) {
        __typename
        url
        transactionId
        fields {
          __typename
          key
          AWSAccessKeyId
          XAMZSecurityToken
          policy
          signature
        }
      }
    }
    """

  public let operationName: String = "getS3PreSingedURL"

  public var vin: String

  public init(vin: String) {
    self.vin = vin
  }

  public var variables: GraphQLMap? {
    return ["vin": vin]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("getS3PreSingedURL", arguments: ["vin": GraphQLVariable("vin")], type: .nonNull(.object(GetS3PreSingedUrl.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(getS3PreSingedUrl: GetS3PreSingedUrl) {
      self.init(unsafeResultMap: ["__typename": "Query", "getS3PreSingedURL": getS3PreSingedUrl.resultMap])
    }

    public var getS3PreSingedUrl: GetS3PreSingedUrl {
      get {
        return GetS3PreSingedUrl(unsafeResultMap: resultMap["getS3PreSingedURL"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "getS3PreSingedURL")
      }
    }

    public struct GetS3PreSingedUrl: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["S3PreSignedURL"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("url", type: .nonNull(.scalar(String.self))),
          GraphQLField("transactionId", type: .nonNull(.scalar(String.self))),
          GraphQLField("fields", type: .nonNull(.object(Field.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(url: String, transactionId: String, fields: Field) {
        self.init(unsafeResultMap: ["__typename": "S3PreSignedURL", "url": url, "transactionId": transactionId, "fields": fields.resultMap])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// The generated pre-signed URL to upload files into S3 bucket - from AWS
      public var url: String {
        get {
          return resultMap["url"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "url")
        }
      }

      /// An unique id generated for each request which will be passed along with inputs to the BSMCapacity and StateOfCharge mutation calls
      public var transactionId: String {
        get {
          return resultMap["transactionId"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "transactionId")
        }
      }

      /// The generated pre-signed URL fields to upload files into S2 bucket - from AWS
      public var fields: Field {
        get {
          return Field(unsafeResultMap: resultMap["fields"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "fields")
        }
      }

      public struct Field: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["preSignedURLFields"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("key", type: .nonNull(.scalar(String.self))),
            GraphQLField("AWSAccessKeyId", type: .nonNull(.scalar(String.self))),
            GraphQLField("XAMZSecurityToken", type: .nonNull(.scalar(String.self))),
            GraphQLField("policy", type: .nonNull(.scalar(String.self))),
            GraphQLField("signature", type: .nonNull(.scalar(String.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(key: String, awsAccessKeyId: String, xamzSecurityToken: String, policy: String, signature: String) {
          self.init(unsafeResultMap: ["__typename": "preSignedURLFields", "key": key, "AWSAccessKeyId": awsAccessKeyId, "XAMZSecurityToken": xamzSecurityToken, "policy": policy, "signature": signature])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// S3 key to indentify the object
        public var key: String {
          get {
            return resultMap["key"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "key")
          }
        }

        /// Access key used to sign programmatic requests that you make to AWS
        public var awsAccessKeyId: String {
          get {
            return resultMap["AWSAccessKeyId"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "AWSAccessKeyId")
          }
        }

        /// The temporary security token that will be obtained through a call to AWS STS
        public var xamzSecurityToken: String {
          get {
            return resultMap["XAMZSecurityToken"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "XAMZSecurityToken")
          }
        }

        /// An AWS object defines the AWS resource permission
        public var policy: String {
          get {
            return resultMap["policy"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "policy")
          }
        }

        /// It's an authentication information added to AWS API requests sent by HTTP
        public var signature: String {
          get {
            return resultMap["signature"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "signature")
          }
        }
      }
    }
  }
}

public final class SubmitBatteryJsonFilesWithStateOfChargeMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation SubmitBatteryJSONFilesWithStateOfCharge($Vehicle: SubmitBatteryDataFilesVehicleInput!, $calculateBatteryHealthInput: CalculateBatteryHealthInput!) {
      calculateBatteryHealth(
        vehicle: $Vehicle
        calculateBatteryHealthInput: $calculateBatteryHealthInput
      ) {
        __typename
        code
        message
        success
        calculatedBatteryHealth {
          __typename
          batteryScore {
            __typename
            score
            grade
            health
            factorsUsed {
              __typename
              name
              type
            }
          }
          estimatedRange {
            __typename
            estimatedRangeMin
            estimatedRangeMax
          }
        }
      }
    }
    """

  public let operationName: String = "SubmitBatteryJSONFilesWithStateOfCharge"

  public var Vehicle: SubmitBatteryDataFilesVehicleInput
  public var calculateBatteryHealthInput: CalculateBatteryHealthInput

  public init(Vehicle: SubmitBatteryDataFilesVehicleInput, calculateBatteryHealthInput: CalculateBatteryHealthInput) {
    self.Vehicle = Vehicle
    self.calculateBatteryHealthInput = calculateBatteryHealthInput
  }

  public var variables: GraphQLMap? {
    return ["Vehicle": Vehicle, "calculateBatteryHealthInput": calculateBatteryHealthInput]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("calculateBatteryHealth", arguments: ["vehicle": GraphQLVariable("Vehicle"), "calculateBatteryHealthInput": GraphQLVariable("calculateBatteryHealthInput")], type: .object(CalculateBatteryHealth.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(calculateBatteryHealth: CalculateBatteryHealth? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "calculateBatteryHealth": calculateBatteryHealth.flatMap { (value: CalculateBatteryHealth) -> ResultMap in value.resultMap }])
    }

    public var calculateBatteryHealth: CalculateBatteryHealth? {
      get {
        return (resultMap["calculateBatteryHealth"] as? ResultMap).flatMap { CalculateBatteryHealth(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "calculateBatteryHealth")
      }
    }

    public struct CalculateBatteryHealth: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["CalculateBatteryHealthResponse"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("code", type: .nonNull(.scalar(String.self))),
          GraphQLField("message", type: .nonNull(.scalar(String.self))),
          GraphQLField("success", type: .nonNull(.scalar(Bool.self))),
          GraphQLField("calculatedBatteryHealth", type: .object(CalculatedBatteryHealth.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(code: String, message: String, success: Bool, calculatedBatteryHealth: CalculatedBatteryHealth? = nil) {
        self.init(unsafeResultMap: ["__typename": "CalculateBatteryHealthResponse", "code": code, "message": message, "success": success, "calculatedBatteryHealth": calculatedBatteryHealth.flatMap { (value: CalculatedBatteryHealth) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var code: String {
        get {
          return resultMap["code"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "code")
        }
      }

      public var message: String {
        get {
          return resultMap["message"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "message")
        }
      }

      public var success: Bool {
        get {
          return resultMap["success"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "success")
        }
      }

      public var calculatedBatteryHealth: CalculatedBatteryHealth? {
        get {
          return (resultMap["calculatedBatteryHealth"] as? ResultMap).flatMap { CalculatedBatteryHealth(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "calculatedBatteryHealth")
        }
      }

      public struct CalculatedBatteryHealth: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["CalculatedBatteryHealth"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("batteryScore", type: .object(BatteryScore.selections)),
            GraphQLField("estimatedRange", type: .object(EstimatedRange.selections)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(batteryScore: BatteryScore? = nil, estimatedRange: EstimatedRange? = nil) {
          self.init(unsafeResultMap: ["__typename": "CalculatedBatteryHealth", "batteryScore": batteryScore.flatMap { (value: BatteryScore) -> ResultMap in value.resultMap }, "estimatedRange": estimatedRange.flatMap { (value: EstimatedRange) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var batteryScore: BatteryScore? {
          get {
            return (resultMap["batteryScore"] as? ResultMap).flatMap { BatteryScore(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "batteryScore")
          }
        }

        public var estimatedRange: EstimatedRange? {
          get {
            return (resultMap["estimatedRange"] as? ResultMap).flatMap { EstimatedRange(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "estimatedRange")
          }
        }

        public struct BatteryScore: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["BatteryScore"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("score", type: .nonNull(.scalar(Double.self))),
              GraphQLField("grade", type: .nonNull(.scalar(Grade.self))),
              GraphQLField("health", type: .nonNull(.scalar(Health.self))),
              GraphQLField("factorsUsed", type: .nonNull(.list(.object(FactorsUsed.selections)))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(score: Double, grade: Grade, health: Health, factorsUsed: [FactorsUsed?]) {
            self.init(unsafeResultMap: ["__typename": "BatteryScore", "score": score, "grade": grade, "health": health, "factorsUsed": factorsUsed.map { (value: FactorsUsed?) -> ResultMap? in value.flatMap { (value: FactorsUsed) -> ResultMap in value.resultMap } }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The given vehicle's battery score value, on a scale of 1.0 to 5.0 inclusive
          public var score: Double {
            get {
              return resultMap["score"]! as! Double
            }
            set {
              resultMap.updateValue(newValue, forKey: "score")
            }
          }

          /// The given vehicle's battery score grade value
          public var grade: Grade {
            get {
              return resultMap["grade"]! as! Grade
            }
            set {
              resultMap.updateValue(newValue, forKey: "grade")
            }
          }

          /// The given vehicle's battery score health value
          public var health: Health {
            get {
              return resultMap["health"]! as! Health
            }
            set {
              resultMap.updateValue(newValue, forKey: "health")
            }
          }

          /// The list of Factor objects used in the Battery Score calculation
          public var factorsUsed: [FactorsUsed?] {
            get {
              return (resultMap["factorsUsed"] as! [ResultMap?]).map { (value: ResultMap?) -> FactorsUsed? in value.flatMap { (value: ResultMap) -> FactorsUsed in FactorsUsed(unsafeResultMap: value) } }
            }
            set {
              resultMap.updateValue(newValue.map { (value: FactorsUsed?) -> ResultMap? in value.flatMap { (value: FactorsUsed) -> ResultMap in value.resultMap } }, forKey: "factorsUsed")
            }
          }

          public struct FactorsUsed: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Factor"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("name", type: .nonNull(.scalar(String.self))),
                GraphQLField("type", type: .nonNull(.scalar(TypeSource.self))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(name: String, type: TypeSource) {
              self.init(unsafeResultMap: ["__typename": "Factor", "name": name, "type": type])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// The given factor's name.
            public var name: String {
              get {
                return resultMap["name"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "name")
              }
            }

            /// The given factor's type.
            public var type: TypeSource {
              get {
                return resultMap["type"]! as! TypeSource
              }
              set {
                resultMap.updateValue(newValue, forKey: "type")
              }
            }
          }
        }

        public struct EstimatedRange: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["EstimatedRange"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("estimatedRangeMin", type: .scalar(Double.self)),
              GraphQLField("estimatedRangeMax", type: .scalar(Double.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(estimatedRangeMin: Double? = nil, estimatedRangeMax: Double? = nil) {
            self.init(unsafeResultMap: ["__typename": "EstimatedRange", "estimatedRangeMin": estimatedRangeMin, "estimatedRangeMax": estimatedRangeMax])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The given vehicle's minimum estimated range calculation.
          public var estimatedRangeMin: Double? {
            get {
              return resultMap["estimatedRangeMin"] as? Double
            }
            set {
              resultMap.updateValue(newValue, forKey: "estimatedRangeMin")
            }
          }

          /// The given vehicle's maximum estimated range calculation.
          public var estimatedRangeMax: Double? {
            get {
              return resultMap["estimatedRangeMax"] as? Double
            }
            set {
              resultMap.updateValue(newValue, forKey: "estimatedRangeMax")
            }
          }
        }
      }
    }
  }
}

public final class SubmitBatteryFilesWithStateOfChargeMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation SubmitBatteryFilesWithStateOfCharge($Vehicle: SubmitBatteryDataFilesVehicleInput!, $submitBatteryDataFilesProps: SubmitBatteryDataFilesPropsInput!, $stateOfChargeProps: StateOfChargePropsInput!) {
      submitBatteryDataFilesWithStateOfCharge(
        Vehicle: $Vehicle
        submitBatteryDataFilesProps: $submitBatteryDataFilesProps
        stateOfChargeProps: $stateOfChargeProps
      ) {
        __typename
        estimatedRange {
          __typename
          estimatedRangeMin
          estimatedRangeMax
        }
        batteryScore {
          __typename
          score
          grade
          health
          factorsUsed {
            __typename
            name
            type
          }
        }
      }
    }
    """

  public let operationName: String = "SubmitBatteryFilesWithStateOfCharge"

  public var Vehicle: SubmitBatteryDataFilesVehicleInput
  public var submitBatteryDataFilesProps: SubmitBatteryDataFilesPropsInput
  public var stateOfChargeProps: StateOfChargePropsInput

  public init(Vehicle: SubmitBatteryDataFilesVehicleInput, submitBatteryDataFilesProps: SubmitBatteryDataFilesPropsInput, stateOfChargeProps: StateOfChargePropsInput) {
    self.Vehicle = Vehicle
    self.submitBatteryDataFilesProps = submitBatteryDataFilesProps
    self.stateOfChargeProps = stateOfChargeProps
  }

  public var variables: GraphQLMap? {
    return ["Vehicle": Vehicle, "submitBatteryDataFilesProps": submitBatteryDataFilesProps, "stateOfChargeProps": stateOfChargeProps]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("submitBatteryDataFilesWithStateOfCharge", arguments: ["Vehicle": GraphQLVariable("Vehicle"), "submitBatteryDataFilesProps": GraphQLVariable("submitBatteryDataFilesProps"), "stateOfChargeProps": GraphQLVariable("stateOfChargeProps")], type: .object(SubmitBatteryDataFilesWithStateOfCharge.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(submitBatteryDataFilesWithStateOfCharge: SubmitBatteryDataFilesWithStateOfCharge? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "submitBatteryDataFilesWithStateOfCharge": submitBatteryDataFilesWithStateOfCharge.flatMap { (value: SubmitBatteryDataFilesWithStateOfCharge) -> ResultMap in value.resultMap }])
    }

    @available(*, deprecated, message: "A new endpoint 'calculateBatteryHealth' has been created which supports Json file input.")
    public var submitBatteryDataFilesWithStateOfCharge: SubmitBatteryDataFilesWithStateOfCharge? {
      get {
        return (resultMap["submitBatteryDataFilesWithStateOfCharge"] as? ResultMap).flatMap { SubmitBatteryDataFilesWithStateOfCharge(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "submitBatteryDataFilesWithStateOfCharge")
      }
    }

    public struct SubmitBatteryDataFilesWithStateOfCharge: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["SubmitBatteryDataResponse"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("estimatedRange", type: .object(EstimatedRange.selections)),
          GraphQLField("batteryScore", type: .object(BatteryScore.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(estimatedRange: EstimatedRange? = nil, batteryScore: BatteryScore? = nil) {
        self.init(unsafeResultMap: ["__typename": "SubmitBatteryDataResponse", "estimatedRange": estimatedRange.flatMap { (value: EstimatedRange) -> ResultMap in value.resultMap }, "batteryScore": batteryScore.flatMap { (value: BatteryScore) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var estimatedRange: EstimatedRange? {
        get {
          return (resultMap["estimatedRange"] as? ResultMap).flatMap { EstimatedRange(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "estimatedRange")
        }
      }

      public var batteryScore: BatteryScore? {
        get {
          return (resultMap["batteryScore"] as? ResultMap).flatMap { BatteryScore(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "batteryScore")
        }
      }

      public struct EstimatedRange: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["EstimatedRange"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("estimatedRangeMin", type: .scalar(Double.self)),
            GraphQLField("estimatedRangeMax", type: .scalar(Double.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(estimatedRangeMin: Double? = nil, estimatedRangeMax: Double? = nil) {
          self.init(unsafeResultMap: ["__typename": "EstimatedRange", "estimatedRangeMin": estimatedRangeMin, "estimatedRangeMax": estimatedRangeMax])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// The given vehicle's minimum estimated range calculation.
        public var estimatedRangeMin: Double? {
          get {
            return resultMap["estimatedRangeMin"] as? Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "estimatedRangeMin")
          }
        }

        /// The given vehicle's maximum estimated range calculation.
        public var estimatedRangeMax: Double? {
          get {
            return resultMap["estimatedRangeMax"] as? Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "estimatedRangeMax")
          }
        }
      }

      public struct BatteryScore: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["BatteryScore"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("score", type: .nonNull(.scalar(Double.self))),
            GraphQLField("grade", type: .nonNull(.scalar(Grade.self))),
            GraphQLField("health", type: .nonNull(.scalar(Health.self))),
            GraphQLField("factorsUsed", type: .nonNull(.list(.object(FactorsUsed.selections)))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(score: Double, grade: Grade, health: Health, factorsUsed: [FactorsUsed?]) {
          self.init(unsafeResultMap: ["__typename": "BatteryScore", "score": score, "grade": grade, "health": health, "factorsUsed": factorsUsed.map { (value: FactorsUsed?) -> ResultMap? in value.flatMap { (value: FactorsUsed) -> ResultMap in value.resultMap } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// The given vehicle's battery score value, on a scale of 1.0 to 5.0 inclusive
        public var score: Double {
          get {
            return resultMap["score"]! as! Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "score")
          }
        }

        /// The given vehicle's battery score grade value
        public var grade: Grade {
          get {
            return resultMap["grade"]! as! Grade
          }
          set {
            resultMap.updateValue(newValue, forKey: "grade")
          }
        }

        /// The given vehicle's battery score health value
        public var health: Health {
          get {
            return resultMap["health"]! as! Health
          }
          set {
            resultMap.updateValue(newValue, forKey: "health")
          }
        }

        /// The list of Factor objects used in the Battery Score calculation
        public var factorsUsed: [FactorsUsed?] {
          get {
            return (resultMap["factorsUsed"] as! [ResultMap?]).map { (value: ResultMap?) -> FactorsUsed? in value.flatMap { (value: ResultMap) -> FactorsUsed in FactorsUsed(unsafeResultMap: value) } }
          }
          set {
            resultMap.updateValue(newValue.map { (value: FactorsUsed?) -> ResultMap? in value.flatMap { (value: FactorsUsed) -> ResultMap in value.resultMap } }, forKey: "factorsUsed")
          }
        }

        public struct FactorsUsed: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Factor"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("name", type: .nonNull(.scalar(String.self))),
              GraphQLField("type", type: .nonNull(.scalar(TypeSource.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(name: String, type: TypeSource) {
            self.init(unsafeResultMap: ["__typename": "Factor", "name": name, "type": type])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The given factor's name.
          public var name: String {
            get {
              return resultMap["name"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "name")
            }
          }

          /// The given factor's type.
          public var type: TypeSource {
            get {
              return resultMap["type"]! as! TypeSource
            }
            set {
              resultMap.updateValue(newValue, forKey: "type")
            }
          }
        }
      }
    }
  }
}

public final class SubmitBatteryDataFilesWithBmsCapacityMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation SubmitBatteryDataFilesWithBmsCapacity($Vehicle: SubmitBatteryDataFilesVehicleInput!, $submitBatteryDataFilesProps: SubmitBatteryDataFilesPropsInput!, $bmsCapacityProps: BMSCapacityPropsInput!) {
      submitBatteryDataFilesWithBmsCapacity(
        Vehicle: $Vehicle
        submitBatteryDataFilesProps: $submitBatteryDataFilesProps
        bmsCapacityProps: $bmsCapacityProps
      ) {
        __typename
        estimatedRange {
          __typename
          estimatedRangeMin
          estimatedRangeMax
        }
        batteryScore {
          __typename
          score
          grade
          health
          factorsUsed {
            __typename
            name
            type
          }
        }
      }
    }
    """

  public let operationName: String = "SubmitBatteryDataFilesWithBmsCapacity"

  public var Vehicle: SubmitBatteryDataFilesVehicleInput
  public var submitBatteryDataFilesProps: SubmitBatteryDataFilesPropsInput
  public var bmsCapacityProps: BMSCapacityPropsInput

  public init(Vehicle: SubmitBatteryDataFilesVehicleInput, submitBatteryDataFilesProps: SubmitBatteryDataFilesPropsInput, bmsCapacityProps: BMSCapacityPropsInput) {
    self.Vehicle = Vehicle
    self.submitBatteryDataFilesProps = submitBatteryDataFilesProps
    self.bmsCapacityProps = bmsCapacityProps
  }

  public var variables: GraphQLMap? {
    return ["Vehicle": Vehicle, "submitBatteryDataFilesProps": submitBatteryDataFilesProps, "bmsCapacityProps": bmsCapacityProps]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("submitBatteryDataFilesWithBmsCapacity", arguments: ["Vehicle": GraphQLVariable("Vehicle"), "submitBatteryDataFilesProps": GraphQLVariable("submitBatteryDataFilesProps"), "bmsCapacityProps": GraphQLVariable("bmsCapacityProps")], type: .object(SubmitBatteryDataFilesWithBmsCapacity.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(submitBatteryDataFilesWithBmsCapacity: SubmitBatteryDataFilesWithBmsCapacity? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "submitBatteryDataFilesWithBmsCapacity": submitBatteryDataFilesWithBmsCapacity.flatMap { (value: SubmitBatteryDataFilesWithBmsCapacity) -> ResultMap in value.resultMap }])
    }

    @available(*, deprecated, message: "A new endpoint 'calculateBatteryHealth' has been created which supports Json file input.")
    public var submitBatteryDataFilesWithBmsCapacity: SubmitBatteryDataFilesWithBmsCapacity? {
      get {
        return (resultMap["submitBatteryDataFilesWithBmsCapacity"] as? ResultMap).flatMap { SubmitBatteryDataFilesWithBmsCapacity(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "submitBatteryDataFilesWithBmsCapacity")
      }
    }

    public struct SubmitBatteryDataFilesWithBmsCapacity: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["SubmitBatteryDataResponse"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("estimatedRange", type: .object(EstimatedRange.selections)),
          GraphQLField("batteryScore", type: .object(BatteryScore.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(estimatedRange: EstimatedRange? = nil, batteryScore: BatteryScore? = nil) {
        self.init(unsafeResultMap: ["__typename": "SubmitBatteryDataResponse", "estimatedRange": estimatedRange.flatMap { (value: EstimatedRange) -> ResultMap in value.resultMap }, "batteryScore": batteryScore.flatMap { (value: BatteryScore) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var estimatedRange: EstimatedRange? {
        get {
          return (resultMap["estimatedRange"] as? ResultMap).flatMap { EstimatedRange(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "estimatedRange")
        }
      }

      public var batteryScore: BatteryScore? {
        get {
          return (resultMap["batteryScore"] as? ResultMap).flatMap { BatteryScore(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "batteryScore")
        }
      }

      public struct EstimatedRange: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["EstimatedRange"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("estimatedRangeMin", type: .scalar(Double.self)),
            GraphQLField("estimatedRangeMax", type: .scalar(Double.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(estimatedRangeMin: Double? = nil, estimatedRangeMax: Double? = nil) {
          self.init(unsafeResultMap: ["__typename": "EstimatedRange", "estimatedRangeMin": estimatedRangeMin, "estimatedRangeMax": estimatedRangeMax])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// The given vehicle's minimum estimated range calculation.
        public var estimatedRangeMin: Double? {
          get {
            return resultMap["estimatedRangeMin"] as? Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "estimatedRangeMin")
          }
        }

        /// The given vehicle's maximum estimated range calculation.
        public var estimatedRangeMax: Double? {
          get {
            return resultMap["estimatedRangeMax"] as? Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "estimatedRangeMax")
          }
        }
      }

      public struct BatteryScore: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["BatteryScore"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("score", type: .nonNull(.scalar(Double.self))),
            GraphQLField("grade", type: .nonNull(.scalar(Grade.self))),
            GraphQLField("health", type: .nonNull(.scalar(Health.self))),
            GraphQLField("factorsUsed", type: .nonNull(.list(.object(FactorsUsed.selections)))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(score: Double, grade: Grade, health: Health, factorsUsed: [FactorsUsed?]) {
          self.init(unsafeResultMap: ["__typename": "BatteryScore", "score": score, "grade": grade, "health": health, "factorsUsed": factorsUsed.map { (value: FactorsUsed?) -> ResultMap? in value.flatMap { (value: FactorsUsed) -> ResultMap in value.resultMap } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// The given vehicle's battery score value, on a scale of 1.0 to 5.0 inclusive
        public var score: Double {
          get {
            return resultMap["score"]! as! Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "score")
          }
        }

        /// The given vehicle's battery score grade value
        public var grade: Grade {
          get {
            return resultMap["grade"]! as! Grade
          }
          set {
            resultMap.updateValue(newValue, forKey: "grade")
          }
        }

        /// The given vehicle's battery score health value
        public var health: Health {
          get {
            return resultMap["health"]! as! Health
          }
          set {
            resultMap.updateValue(newValue, forKey: "health")
          }
        }

        /// The list of Factor objects used in the Battery Score calculation
        public var factorsUsed: [FactorsUsed?] {
          get {
            return (resultMap["factorsUsed"] as! [ResultMap?]).map { (value: ResultMap?) -> FactorsUsed? in value.flatMap { (value: ResultMap) -> FactorsUsed in FactorsUsed(unsafeResultMap: value) } }
          }
          set {
            resultMap.updateValue(newValue.map { (value: FactorsUsed?) -> ResultMap? in value.flatMap { (value: FactorsUsed) -> ResultMap in value.resultMap } }, forKey: "factorsUsed")
          }
        }

        public struct FactorsUsed: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Factor"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("name", type: .nonNull(.scalar(String.self))),
              GraphQLField("type", type: .nonNull(.scalar(TypeSource.self))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(name: String, type: TypeSource) {
            self.init(unsafeResultMap: ["__typename": "Factor", "name": name, "type": type])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The given factor's name.
          public var name: String {
            get {
              return resultMap["name"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "name")
            }
          }

          /// The given factor's type.
          public var type: TypeSource {
            get {
              return resultMap["type"]! as! TypeSource
            }
            set {
              resultMap.updateValue(newValue, forKey: "type")
            }
          }
        }
      }
    }
  }
}
