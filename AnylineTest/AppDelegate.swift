//
//  AppDelegate.swift
//  AnylineTest
//
//  Created by Vimal Venugopalan on 26/05/23.
//

import UIKit
import Anyline
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        do {
            try AnylineSDK.setup(withLicenseKey: "ewogICJsaWNlbnNlS2V5VmVyc2lvbiIgOiAiMy4wIiwKICAiZGVidWdSZXBvcnRpbmciIDogIm9uIiwKICAibWFqb3JWZXJzaW9uIiA6ICIzNyIsCiAgIm1heERheXNOb3RSZXBvcnRlZCIgOiA1LAogICJhZHZhbmNlZEJhcmNvZGUiIDogdHJ1ZSwKICAibXVsdGlCYXJjb2RlIiA6IHRydWUsCiAgInN1cHBvcnRlZEJhcmNvZGVGb3JtYXRzIiA6IFsgIkFMTCIgXSwKICAicGxhdGZvcm0iIDogWyAiQW5kcm9pZCIsICJpT1MiLCAiV2luZG93cyIsICJXZWIiLCAiSlMiIF0sCiAgInNjb3BlIiA6IFsgIkFMTCIgXSwKICAic2hvd1dhdGVybWFyayIgOiB0cnVlLAogICJ0b2xlcmFuY2VEYXlzIiA6IDMwLAogICJ2YWxpZCIgOiAiMjAyMy0wNi0zMCIsCiAgImxpY2Vuc2VJZCIgOiAiOWxuTmU0OUdnTVZJZEpHVEU0RUxmQVhVeUJhT3lzSEUzcHhaNjlZVGsiLAogICJpb3NJZGVudGlmaWVyIiA6IFsgIlZpbWFsLkFueWxpbmVUZXN0IiBdLAogICJhbmRyb2lkSWRlbnRpZmllciIgOiBbICJWaW1hbC5BbnlsaW5lVGVzdCIgXSwKICAid2luZG93c0lkZW50aWZpZXIiIDogWyAiVmltYWwuQW55bGluZVRlc3QiIF0sCiAgImpzSWRlbnRpZmllciIgOiBbICJWaW1hbC5BbnlsaW5lVGVzdCIgXSwKICAid2ViSWRlbnRpZmllciIgOiBbICJWaW1hbC5BbnlsaW5lVGVzdCIgXQp9CgoyV2JEemp1YnZpcDJmd3FjdDgxSW0zNmljMW1yNkxvcVU4Q28vN0xlQnErUFBBKzdKQXBXMStxQ01xN1hkdTBlM2pCYmVRdk5BdUlqeVhQYzI5UFhBbjdGYVRKZUowWjhxbDNZbERsS1Y0MWFLTC9kQjJMQlBFRmZIUTZZM01BZzE1NDFtV3VSNDh4ZWFEOE00UFl1dWpETHg4NkpGMGl3VzhGRG82MGhJQXJiRCtzR0wvNi9OS2NrMXhaZ1g0alBQKzVxS1RyeHQ0c1R0MEw5SnFVQnNYRkhTNU1DblJ0L01iRXRWSWlyU3RxTlFLNjhhTFllMUJjaDh5RktVRFdVQXdEZGFlaXJIVzkzOTh6ZnpjZWpPMFVZdm05eXBVa3ptR3FRK2hlby84ZGszT28zT01aSUplTGdPeFVnTERoWWk3SjNWL3llcElWZC9BZnJRVXltcGc9PQ==")
        } catch let e {
            print(e)
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

