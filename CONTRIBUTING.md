<!-- omit in toc -->
# Contributing to MiniCampus

First of all, thank you 🤩 for picking interest in MiniCampus and taking time to contribute 😉

All types of contributions are encouraged and valued. See the [Table of Contents](#table-of-contents) for different ways to help and details about how this project handles them. Please make sure to read the relevant section before making your contribution. It will make it a lot easier for us maintainers and smooth out the experience for all involved. The community looks forward to your contributions. 🎉

> And if you like the project, but just don't have time to contribute, that's fine. There are other easy ways to support the project and show your appreciation, which we would also be very happy about:
> - Share with friends
> - Leave a review on app store
> - Star the project
> - Tweet about it
> - Refer this project in your project's readme
> - Mention the project at local meetups and tell your friends/colleagues

## First contribution?
You are not alone, luckliy there are tonnes of information on how to get started with open source contributions. 
Follow this [comprehensive guide](https://github.com/firstcontributions/first-contributions) for getting started contributing to open source.

<!-- omit in toc -->
## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [I Have a Question](#i-have-a-question)
- [I Want To Contribute](#i-want-to-contribute)
- [Reporting Bugs](#reporting-bugs)
- [Suggesting Enhancements](#suggesting-enhancements)
- [Your First Code Contribution](#your-first-code-contribution)
- [Improving The Documentation](#improving-the-documentation)
- [Styleguides](#styleguides)
- [Commit Messages](#commit-messages)
- [Join The Project Team](#join-the-project-team)


## Code of Conduct

This project and everyone participating in it is governed by the
[Code of Conduct](CODE_OF_CONDUCT.md).
By participating, you are expected to uphold this code. Please report unacceptable behavior
to [email](mailto:donnclab@gmail.com).


## I Have a Question

> If you want to ask a question, we assume that you have read the available [Documentation*]().

Before you ask a question, it is best to search for existing [Issues](https://github.com/DonnC-Lab/mini_campus/issues) that might help you. In case you have found a suitable issue and still need clarification, you can write your question in this issue. It is also advisable to search the internet for answers first.

If you then still feel the need to ask a question and need clarification, we recommend the following:

- Open an [Issue](https://github.com/DonnC-Lab/mini_campus/issues/new).
- Provide as much context as you can about what you're running into.
- Provide project and platform versions (nodejs, npm, etc), depending on what seems relevant.

We will then take care of the issue as soon as possible.

<!--
You might want to create a separate issue tag for questions and include it in this description. People should then tag their issues accordingly.

Depending on how large the project is, you may want to outsource the questioning, e.g. to Stack Overflow or Gitter. You may add additional contact and information possibilities:
- IRC
- Slack
- Gitter
- Stack Overflow tag
- Blog
- FAQ
- Roadmap
- E-Mail List
- Forum
-->

## I Want To Contribute

> ### Legal Notice <!-- omit in toc -->
> When contributing to this project, you must agree that you have authored 100% of the content, that you have the necessary rights to the content and that the content you contribute may be provided under the project license.

### How can i help
There are various ways you can contribute to MC, 2 of the most major contributions are
1. Code fixes and design on existing modules
2. Refactoring, optimization and bug fixes on core modules 
3. Suggesting new Modules

and much more, suggest new ways, bug fixes, typos etc

You can suggest your own module to add, you are free to do so

> **MODULE GOLDEN RULE**

> If adding a module, it can have any logic and functionality ranging from architecture, state management and database you are not restricted to the default way that some core modules have </br>
This is because each module acts like a standalone mini app, however it will be a good practise to always follow best coding guidelines and practises

> If your module has issues for some reasons or faced an exception, it should not affect the operation of other modules


### New module suggestion
Have a new module suggestion? Thats great, thats exactly what we are looking for, be aware that the default state management for the core modules is `riverpod` but you are not limited to this when working on your module. 

Each new module idea must be discussed and pass at least 30% upvote from all active contributors

Once a module idea is approved, the owner has the rights to the module and will be the key maintainer of the module and can give guidelines to other contributors on how to go about that module

The easier way to add your module is creating / converting it to a [flutter package](https://docs.flutter.dev/development/packages-and-plugins/developing-packages#step-1-create-the-package)  

### Connecting your module [Import]
For a detailed solution, check this [How to use packages](https://stackoverflow.com/questions/51238420/how-to-use-local-flutter-package-in-another-flutter-application)

It is reccommended to specify `ref` in order to allow for testing and development based on your module branch
```yaml
  # ...
  relative_scale: ^2.0.0
  intl:

  # add your module
  module_name:
    git: 
      url: https://github.com/<username>/<module>.git
      ref: <branch> # specify module branch e.g main or dev etc
```

All modules are connected within [drawer_module_pages](/lib/src/drawer_module_pages.dart)
```dart
// import your module package
import 'package:<module_name>/<module_name>.dart';

// add your drawer item and link your imported module
[
    // ...
    DrawerPage(
    drawerItem: const DrawerItem(
      icon: YourModule.icon,
      name: 'Module Name',
    ),
    page: const YourModuleEntryWidget(),
  ),
  // ...
]

```

### Accessing *Student*
Your module might want to get the currently logged in Student profile. If you are using `riverpod` state management you must be familiar with reactively listening to the `studentProvider`
```dart
final student = ref.watch(studentProvider);
```

#### Firebase example rules
[Read more](https://medium.com/@juliomacr/10-firebase-realtime-database-rule-templates-d4894a118a98)
```
// Only authenticated users can access/write data
{
 "rules": {
 ".read": "auth != null",
 ".write": "auth != null"
 }
}
```

and only match auth student

```
// Only authenticated users from a particular domain (example.com) can access/write data
{
 "rules": {
 ".read": "auth.token.email.endsWith('@example.com')", // 'students.nust.ac.zw
 ".write": "auth.token.email.endsWith('@example.com')"
 }
}

// storage
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```


### Not using riverpod 🎃
The project saves the same currently logged in student profile to `shared preferences`, you are guaranteed to get the updated student profile 
```dart
// ...

// somewhere in your app do

final sharedPref = await SharedPreferences.getInstance();

final sharedPrefService = SharedPreferencesService(sharedPref);

final Student? student = sharedPrefService.getCachedCurrentStudent();

// do something with student data

// ...
```

### Generate APKs
To build release apps with [flavors](https://stackoverflow.com/questions/63134797/flutter-android-flavors-generate-apk)
```bash
# release apk
$ flutter build apk --release --flavor dev -t lib/main_dev.dart

# release appbundle
$ flutter build appbundle --flavor dev -t lib/main_dev.dart
```

### Design - redesigns
Might include improving existing designs, themes, responsiveness, adaptiveness etc

### Refactoring
Code refactoring, clean code, following best practises, fixing deprecated methods

### Reporting Bugs

<!-- omit in toc -->
#### Before Submitting a Bug Report

A good bug report shouldn't leave others needing to chase you up for more information. Therefore, we ask you to investigate carefully, collect information and describe the issue in detail in your report. Please complete the following steps in advance to help us fix any potential bug as fast as possible.

- Make sure that you are using the latest version.
- Determine if your bug is really a bug and not an error on your side e.g. using incompatible environment components/versions (Make sure that you have read the [documentation](). If you are looking for support, you might want to check [this section](#i-have-a-question)).
- To see if other users have experienced (and potentially already solved) the same issue you are having, check if there is not already a bug report existing for your bug or error in the [bug tracker](https://github.com/DonnC-Lab/mini_campusissues?q=label%3Abug).
- Also make sure to search the internet (including Stack Overflow) to see if users outside of the GitHub community have discussed the issue.
- Collect information about the bug:
- Stack trace (Traceback)
- OS, Platform and Version (Windows, Linux, macOS, x86, ARM)
- Version of the interpreter, compiler, SDK, runtime environment, package manager, depending on what seems relevant.
- Possibly your input and the output
- Can you reliably reproduce the issue? And can you also reproduce it with older versions?

<!-- omit in toc -->
#### How Do I Submit a Good Bug Report?

> You must never report security related issues, vulnerabilities or bugs including sensitive information to the issue tracker, or elsewhere in public. Instead sensitive bugs must be sent by email to <>.
<!-- You may add a PGP key to allow the messages to be sent encrypted as well. -->

We use GitHub issues to track bugs and errors. If you run into an issue with the project:

- Open an [Issue](https://github.com/DonnC-Lab/mini_campus/issues/new). (Since we can't be sure at this point whether it is a bug or not, we ask you not to talk about a bug yet and not to label the issue.)
- Explain the behavior you would expect and the actual behavior.
- Please provide as much context as possible and describe the *reproduction steps* that someone else can follow to recreate the issue on their own. This usually includes your code. For good bug reports you should isolate the problem and create a reduced test case.
- Provide the information you collected in the previous section.
- Each issue should first show the module name and the issue name e.g
```
[MODULE-NAME] Issue name

e.g
[VOTING] Textfield failing to reset
```

Once it's filed:

- The project team will label the issue accordingly.
- A team member will try to reproduce the issue with your provided steps. If there are no reproduction steps or no obvious way to reproduce the issue, the team will ask you for those steps and mark the issue as `needs-repro`. Bugs with the `needs-repro` tag will not be addressed until they are reproduced.
- If the team is able to reproduce the issue, it will be marked `needs-fix`, as well as possibly other tags (such as `critical`), and the issue will be left to be [implemented by someone](#your-first-code-contribution).

<!-- You might want to create an issue template for bugs and errors that can be used as a guide and that defines the structure of the information to be included. If you do so, reference it here in the description. -->


### Suggesting Enhancements

This section guides you through submitting an enhancement suggestion for MiniCampus, **including completely new features and minor improvements to existing functionality**. Following these guidelines will help maintainers and the community to understand your suggestion and find related suggestions.

<!-- omit in toc -->
#### Before Submitting an Enhancement

- Make sure that you are using the latest version.
- Read the [documentation]() carefully and find out if the functionality is already covered, maybe by an individual configuration.
- Perform a [search](https://github.com/DonnC-Lab/mini_campus/issues) to see if the enhancement has already been suggested. If it has, add a comment to the existing issue instead of opening a new one.
- Find out whether your idea fits with the scope and aims of the project. It's up to you to make a strong case to convince the project's developers of the merits of this feature. Keep in mind that we want features that will be useful to the majority of our users and not just a small subset. If you're just targeting a minority of users, consider writing an add-on/plugin library.

<!-- omit in toc -->
#### How Do I Submit a Good Enhancement Suggestion?

Enhancement suggestions are tracked as [GitHub issues](https://github.com/DonnC-Lab/mini_campus/issues).

- Use a **clear and descriptive title** for the issue to identify the suggestion.
- Provide a **step-by-step description of the suggested enhancement** in as many details as possible.
- **Describe the current behavior** and **explain which behavior you expected to see instead** and why. At this point you can also tell which alternatives do not work for you.
- You may want to **include screenshots and animated GIFs** which help you demonstrate the steps or point out the part which the suggestion is related to. You can use [this tool](https://www.cockos.com/licecap/) to record GIFs on macOS and Windows, and [this tool](https://github.com/colinkeenan/silentcast) or [this tool](https://github.com/GNOME/byzanz) on Linux. <!-- this should only be included if the project has a GUI -->
- **Explain why this enhancement would be useful** to most MiniCampus users. You may also want to point out the other projects that solved it better and which could serve as inspiration.

<!-- You might want to create an issue template for enhancement suggestions that can be used as a guide and that defines the structure of the information to be included. If you do so, reference it here in the description. -->

### Your First Code Contribution
<!-- TODO
include Setup of env, IDE and typical getting started instructions?

-->

### Improving The Documentation
<!-- TODO
Updating, improving and correcting the documentation
-->
*link coming soon*

## Styleguides
### Commit Messages
<!-- TODO

-->

## Join The Project Team
<!-- TODO -->
*link coming soon*

<!-- omit in toc -->
## Attribution
This guide is based on the **contributing-gen**. [Make your own](https://github.com/bttger/contributing-gen)!