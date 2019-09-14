# SquareRepos
iOS Application listing the Square repositories


### Specification:

Xcode 10.3
Swift 5
Development Target - iOS 12.4


### Problem Statement
iOS Application that fetches list of Square repositories from, https://api.github.com/orgs/square/repos. The JSON result is parsed and displayed in a list with name and description for each.


### Used MVVM architectural pattern with following classes achieving their respective roles:

``RepoListViewController`` - View, handle presenting the repository list(name and description for each) to UI and taking up the user interactions.

``Repository`` - Model, representing the data.

``RepoViewModel`` - ViewModel, handling the communication between View and the Model. Used RxSwift for establishing the binding.



### The Data flow used can be explained as below: 

1. UI calls method from ViewModel to request data.
2. ViewModel calls the respective data repository.
3. Use case combines data from User and Post Repositories.
4. Each Repository returns data from a Data Source (Cached or Remote). Singleton class ``DataManager`` achieve this in my application.
5. Information flows back to the ViewModel, where we display the list of posts.

### Installation:

Used pods, thus, run ``pod intall`` command to download the dependencies.
