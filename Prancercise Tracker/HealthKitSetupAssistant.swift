/**
 * Copyright (c) 2019 BaraLabs LLC
 */

import HealthKit

class HealthKitSetupAssistant {
  
  private enum HealthkitSetupError: Error {
    case notAvailableOnDevice
    case dataTypeNotAvailable
  }
  
  class func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Swift.Void) {
    // Check to see if HealthKit Is Available on this device
    guard HKHealthStore.isHealthDataAvailable() else {
        completion(false, HealthkitSetupError.notAvailableOnDevice)
        return
    }
    
    // Prepare the data types that will interact with HealthKit
    guard let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth),
        let bloodType = HKObjectType.characteristicType(forIdentifier: .bloodType),
        let biologicalSex = HKObjectType.characteristicType(forIdentifier: .biologicalSex),
        let bodyMassIndex = HKObjectType.quantityType(forIdentifier: .bodyMassIndex),
        let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass),
        let height = HKObjectType.quantityType(forIdentifier: .height),
        let activeEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)//,
        //let meds = HKClinicalTypeIdentifier.medicationRecord()
        else {
            completion(false,HealthkitSetupError.dataTypeNotAvailable)
            return
    }
    
    // Prepare a list of types you want HealthKit to read and write
    let healthKitTypesToWrite: Set<HKSampleType> = [bodyMassIndex, activeEnergy, HKObjectType.workoutType()]
    let healthKitTypesToRead: Set<HKObjectType> = [dateOfBirth, bloodType, biologicalSex, bodyMassIndex, height, bodyMass,HKObjectType.workoutType()]
    
    // Request authorization
    HKHealthStore().requestAuthorization(toShare: healthKitTypesToWrite, read: healthKitTypesToRead) { (success, error) in
        completion(success, error)
    }

  }
}
