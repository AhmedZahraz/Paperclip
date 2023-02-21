# Paperclip
<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a name="readme-top"></a>
<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Don't forget to give the project a star!
*** Thanks again! Now go create something AMAZING! :D
-->



<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->


<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/othneildrew/Best-README-Template">
    <img src="images/logo.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">Paperclip</h3>

  <p align="center">
    iOS project
    <br />
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
        <li><a href="#prerequisites">Prerequisitesh</a></li>
      </ul>
    </li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

[![Product Name Screen Shot][product-screenshot]](https://example.com)

Ce projet pourrait être utilisé comme un projet de base pour n'importe quel nouveau projet iOS.


<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Prerequisites

Xcode version (min) = 13.2 (pour avoir Swift Concurrency)


### Built With

* Clean Architecutre (Presentation(UIKit), Domain, Data)
* Screaming Architecture
* Swift Concurrency : Async/Await (Presentation --> Domain) (Data ---> Domain)
* MVVM-C : couche Presentation 
* Combine : ViewController <--> ViewModel

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- ROADMAP -->
## Roadmap

- [ ] Ajouter plus de UnitTests (Couches Data et Presentation)
- [ ] Ajouter un "ParserClient" pour pouvoir utiliser un parser personnalisé 
- [ ] Ajouter un "StreamParser" : dans le cas d'un retour serveur important (big json array) : stocker la réponse dans un fichier puis récupérer les éléments "one by one" pour ne pas saturer la mémoire. 
- [ ] Utiliser "UICollectionViewDataSourcePrefetching" pour avoir un scroll plus smooth
- [ ] Ajouter une lib type SwiftGen pour détecter les erreurs strings en "compilation time"
- [ ] Ajouter SwiftLint
- [ ] Multi-language Support
    - [ ] Français
- [ ] Ajouter dans README une section "Acknowledgments"


<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>
