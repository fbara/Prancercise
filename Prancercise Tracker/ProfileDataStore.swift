/**
 * Copyright (c) 2019 BaraLabs LLC
 */

import HealthKit

// Represents your point of access to all of the health-related data for your users
class ProfileDataStore {
    
    class func getAgeSexAndBloodType() throws -> (age: Int, biologicalSex: HKBiologicalSex, bloodType: HKBloodType) {
        
        let healthKitStore = HKHealthStore()
        
        // following can throw an error if user hasn't entered the info
        do {
            // This method throws an error if these data are not available.
            let birthdayComponents = try healthKitStore.dateOfBirthComponents()
            let biologicalSex = try healthKitStore.biologicalSex()
            let bloodType = try healthKitStore.bloodType()
            
            // Use Calendar to calculate age.
            let today = Date()
            let calendar = Calendar.current
            let todayDateComponents = calendar.dateComponents([.year], from: today)
            let thisYear = todayDateComponents.year!
            let age = thisYear - birthdayComponents.year!
            
            // Unwrap the wrappers to get the underlying enum values.
            let unwrappedBiologicalSex = biologicalSex.biologicalSex
            let unwrappedBloodType = bloodType.bloodType
            
            return (age, unwrappedBiologicalSex, unwrappedBloodType)
        }
    }
  
}

