# The ADHD Exploration - WWDC21 Swift Student Challenge Submission
## 👀 Overview
###  Submission Status: Accepted!

Welcome, and thank you for your interest in The ADHD Exploration! This is my submission for the Apple WWDC21 Swift Student Challenge. Inspired by an ADHDer friend of mine, this playground aims to give the best [ADHD](https://www.cdc.gov/ncbddd/adhd/facts.html) advice based on your personality. After taking a personality test based on the [five-factor personality traits](https://www.verywellmind.com/the-big-five-personality-dimensions-2795422), you get one piece of advice correlated with each trait.
### Why build this playground?
We are in a global pandemic right now, and almost all we do is now online. It's become much harder to concentrate as technology can be distracting - this is especially true for people with ADHD. We use technology to solve countless problems every day; why not this one?

All of us are unique; hence, we can't expect our ADHD experience to be the same. This playground understands your personality and how it affects different ADHD symptoms to give you the best advice on managing it.

If you have any questions or just want to chat about the playground, feel free to head over to [discussions](https://github.com/BertanT/The-ADHD-Exploration-WWDC21/discussions)  to do so! 😄
## ❗ Disclaimer
I built this playground only for education, experimentation, and most importantly, for fun! **This playground is not a medical tool nor medical advice. If you have or think you have ADHD, consult with a medical professional to get proper help.** The five-factor personality test here is far from a professional one, so please beware that accuracy may vary. Keep in mind this playground is focused on adults' ADHD.

**While the information you will find in this playground may be helpful, take it with a grain of salt.**
## 🚀 Installation
**Please note that this playground was built for Mac, and the UI is not optimized for iPad.**
1. [Download](https://github.com/BertanT/The-ADHD-Exploration-WWDC21/archive/refs/heads/main.zip) the repository as a `ZIP` archive and expand it. You can also [clone](https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/cloning-a-repository) it :)
2. If not already installed, get the [**Swift Playgrounds App** from the Mac App Store](https://apps.apple.com/app/id1496833156).
3. Open it!
    * If you want to import it to **My Playgrounds** (iCloud Drive):
        1. Launch the Playgrounds app.
        2. From the menu bar; click, File -> Import Playground.
        3. Navigate to your downloaded folder and select `The ADHD Exploration.playgroundbook`.
        4. Click, Open!
    * If you don’t want to import it next to your playgrounds:
        1. Navigate to your downloaded folder using Finder.
        2. Double click on  `The ADHD Exploration.playgroundbook` to open it.
4. Explore and have fun! 😃
## 💻 Usage and Features
### ❗Privacy Warning
This playground saves your data on the `PlaygroundKeyValueStore` - stored on the `.playgroundbook` file itself. This feature enables iCloud synchronization between Mac computers. Beware that copying and pasting this file to share with a friend may reveal your data to them. Please either reset the playground or use the *Delete My Data* option in the more menu before sharing to protect your privacy. The same also applies in the case of iCloud file sharing. You should also set the permission to *Read Only* before sharing on iCloud. Your profile picture is *not* synced to iCloud. With that out of the way, let’s begin!
### Getting Started
1. Click the *Run My Code* button to start execution. Please use Playgrounds in full-screen for the best experience!
2. First, you will see the onboarding screen. Inside it is what I call the inclusive greeting message, which is a text view next to a waving hand emoji that’s cycling through different skin colors. There is also an image view cycling through different Memojis! Enter your preferred name to the text field at the bottom right-hand side of the screen, and click *get started*. Your name is used only for personalization. Read the disclaimer - similar to the one above - and click on *I Understand* if you wish to continue. Don’t worry, your name will **not be saved** to `PlaygroundKeyValueStore` until you click *I Understand*.
3. The playground will then present you with a screen containing primer info. I suggest reading it will help you gain some insight on the topics of ADHD and five-factor personality. Dismiss the view using the x button at the upper right-hand side of your screen to continue.
4. Upon dismissing the info view, you will see your profile. As you haven’t taken it yet, It will ask you to take the fifteen question personality test. Click *Take the test now* to take it!
5. Choose the answer most relevant to you for each question. Please be yourself so the results are as accurate as possible. 😊 You can use the buttons below to navigate through the questions and edit your answers. 
6. After finishing with the test, you will be navigate back to your profile. This time, it will contain your test results and five pieces of advice - one for each trait!
### Profile Picture
You should see a prompt to set a profile picture. Click on it to choose one form your photos library!  To change or remove your profile picture, use the *Settings* section in the *more menu* (`...`)

💡 Pro Tip: Add a Memoji sticker saved to your photo library form iMessage to match the theme of the playground.
### Full List of the *More Menu* Options
The more menu button is located at the upper right-hand side of your screen and represented with a `...` symbol.
* Retake the Test: Used for taking the personality test again. Old results are lost after the new test is completed.
* Learn More: Manually view the primer info page that automatically pops at first launch.
* Show Credits: View a page containing thanks, citations, a small message form me and a countdown to WWDC21!
* Settings -> Change Profile Picture: Change the profile picture.
* Settings -> Remove Profile Picture: Delete the set profile picture.
* Settings -> Delete My Data: Delete all of the user data (user name, profile picture, test results) and stop running the playground for a fresh start. 
## 📝 Minor Differences From Submitted Version
The playground here has minor differences from the one I sent to Apple. They don’t affect the core functionality, and here they are!
* Removed some friends’ Memojis upon their request to respect their privacy :)
* Line comment changes on those referring to my essays for the Swift Student Challenge, as they aren’t provided here.
* I commented out a few lines of code on the submission that make the *Learn More* view automatically pop up on the first launch due to the challenge’s 3-minute time limit. Uncommented them as the view contains pretty nice primer info.
## 🎨 Customization!
### Customizing Memoji
Want to add your Memoji to the title screen? Go ahead and follow these steps!
* Send yourself your Memoji sticker using iMessage or your preferred messaging service. Then drag and drop it onto Finder.
* This step it optional. If you have [Pixelmator Pro](https://www.pixelmator.com/pro/) on your Mac, I highly recommend using the *ML Super Resolution* tool to upscale your Memoji. I used the tool on every Memoji in this playground.
* Rename the file like `memojiR_yourCustomFilenameHere`. **The name must start with `memojiR_`; otherwise, the playground will not detect it.**
* In the Playgrounds app with The ADHD Exploration open, click on the plus symbol in the upper right-hand corner of your screen. On the pop-up view, click on the painting symbol at the top.
* Click on the *Insert From…* button. Navigate to the folder your Memoji image file is in, select it, and click open.
* You should be able to your Memoji on the title screen now. Good Job! 🥳
## 🔭 Contributing 
As you might have guessed, the purpose of this repository is to share my Swift Student Challenge submission with the world and hopefully being an inspiration for you out there. So, I want to keep the `main` branch as I submitted it with no changes other than mandatory maintenance updates to keep it running on the latest version of Swift Playgrounds.

I would be more than happy to hear and implement your ideas into my playground. Please start a new issue if you wish to contribute, and I will create a new branch.
### While contributing, please do not:
* Add or remove Memojis
* Add or remove people from the *Thanks (Memoji Contributors)* section
* Add or remove citations
* Request changes that dramatically alter/damage the core functionality of the playground
## 📚 Citations
**What I read about ADHD, Five Factor Personality, and the correlation between them! All in APA Style, list is also included in the playground.**
* Grice, J. W. (2019, January 4). Five-factor model of personality. Encyclopedia Britannica. https://www.britannica.com/science/five-factor-model-of-personality
* Cherry, K., & Susman, D., PhD. (2021, February 20). What Are the Big 5 Personality Traits? Verywell Mind. https://www.verywellmind.com/the-big-five-personality-dimensions-2795422
* Centers for Disease Control and Prevention. (2021, January 26). What is ADHD? https://www.cdc.gov/ncbddd/adhd/facts.html
* Lange, K. W., Reichl, S., Lange, K. M., Tucha, L., & Tucha, O. (2010). The history of attention deficit hyperactivity disorder. Attention deficit and hyperactivity disorders, 2(4), 241–255. https://doi.org/10.1007/s12402-010-0045-8
* Knouse, L. E., Traeger, L., O’Cleirigh, C., & Safren, S. A. (2013). Adult attention deficit hyperactivity disorder symptoms and five-factor model traits in a clinical sample: a structural equation modeling approach. The Journal of nervous and mental disease, 201(10), 848–854. https://doi.org/10.1097/NMD.0b013e3182a5bf33
## 😊 Thanks!
The Majority of the Memojis used in my playground were created randomly; however, I thought adding some of my friends’ Memojis would be pretty cool. Huge shoutout and thanks to these friends for being super awesome and letting me use theirs! List is also included in the playground.
* Ayşe Silsüpür
* Bedir Ekim - [GitHub](https://github.com/bedirekim)
* Beyza İşkür
* Daniel Karamanoğlu
## 📃 License
Licensed under the MIT License

Copyright (c) 2021 M. Bertan Tarakçıoğlu

