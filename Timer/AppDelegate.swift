/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The app delegate submits task requests and and registers the launch handlers for the app refresh and database cleaning background tasks.
*/

import UIKit
import BackgroundTasks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("did finish launch")
        _ = (window?.rootViewController as? UINavigationController)?.viewControllers.first as? ViewController
    
        
        // MARK: Registering Launch Handlers for Tasks
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.nian.Timer.refresh", using: nil) { task in
            // Downcast the parameter to an app refresh task as this identifier is used for a refresh request.
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
    
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.nian.Timer.register", using: nil) { task in
            // Downcast the parameter to a processing task as this identifier is used for a processing request.
        }

        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("Enter background1")
        scheduleAppRefresh()
    }
    
    // MARK: - Scheduling Tasks
    
    func scheduleAppRefresh() {
        print("app refresh")
        let request = BGAppRefreshTaskRequest(identifier: "com.nian.Timer.refresh")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 1) // Fetch no earlier than 15 minutes from now
        
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }
    // MARK: - Handling Launch for Tasks

    // Fetch the latest feed entries from server.
    func handleAppRefresh(task: BGAppRefreshTask) {
        print("handle refresh")
        scheduleAppRefresh()

        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        
        
        task.expirationHandler = {
            // After all operations are cancelled, the completion block below is called to set the task to complete.
            queue.cancelAllOperations()
        
        }
    }
}
