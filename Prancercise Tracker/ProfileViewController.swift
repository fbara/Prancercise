/**
 * Copyright (c) 2019 BaraLabs LLC
 */

import UIKit
import HealthKit

class ProfileViewController: UITableViewController {
    
  private enum ProfileSection: Int {
    case ageSexBloodType
    case weightHeightBMI
    case readHealthKitData
    case saveBMI
  }
  
  private enum ProfileDataError: Error {
    
    case missingBodyMassIndex
    
    var localizedDescription: String {
      switch self {
      case .missingBodyMassIndex:
        return "Unable to calculate body mass index with available profile data."
      }
    }
  }
  
  @IBOutlet private var ageLabel:UILabel!
  @IBOutlet private var bloodTypeLabel:UILabel!
  @IBOutlet private var biologicalSexLabel:UILabel!
  @IBOutlet private var weightLabel:UILabel!
  @IBOutlet private var heightLabel:UILabel!
  @IBOutlet private var bodyMassIndexLabel:UILabel!
  
  private let userHealthProfile = UserHealthProfile()
  
  private func updateHealthInfo() {
    loadAndDisplayAgeSexAndBloodType()
    loadAndDisplayMostRecentWeight()
    loadAndDisplayMostRecentHeight()
  }
  
  private func loadAndDisplayAgeSexAndBloodType() {
    // uses ProfileDataStore to load biological characteristics
    do {
        // loads age, sex, and blood type as a tuple
        let userAgeSexAndBloodType = try ProfileDataStore.getAgeSexAndBloodType()
        userHealthProfile.age = userAgeSexAndBloodType.age
        userHealthProfile.bloodType = userAgeSexAndBloodType.bloodType
        userHealthProfile.biologicalSex = userAgeSexAndBloodType.biologicalSex
        updateLabels()
    } catch let error {
        self.displayAlert(for: error)
    }

  }
  
  private func updateLabels() {
    // update UI
    if let age = userHealthProfile.age {
        ageLabel.text = "\(age)"
    }
    
    if let biologicalSex = userHealthProfile.biologicalSex {
        biologicalSexLabel.text = biologicalSex.stringRepresentation
    }
    
    if let bloodType = userHealthProfile.bloodType {
        bloodTypeLabel.text = bloodType.stringRepresentation
    }
    
  }
  
  private func loadAndDisplayMostRecentHeight() {

  }
  
  private func loadAndDisplayMostRecentWeight() {

  }
  
  private func saveBodyMassIndexToHealthKit() {
    
  }
  
  private func displayAlert(for error: Error) {
    
    let alert = UIAlertController(title: nil,
                                  message: error.localizedDescription,
                                  preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "O.K.",
                                  style: .default,
                                  handler: nil))
    
    present(alert, animated: true, completion: nil)
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    guard let section = ProfileSection(rawValue: indexPath.section) else {
      fatalError("A ProfileSection should map to the index path's section")
    }
    
    switch section {
    case .saveBMI:
      saveBodyMassIndexToHealthKit()
    case .readHealthKitData:
      updateHealthInfo()
    default: break
    }
  }
}
