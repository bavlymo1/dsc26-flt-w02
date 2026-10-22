\# AI Usage Report



\## 1. Tools Used

\- Gemini in Workspace

\- ChatGPT / GitHub Copilot



\## 2. Most Useful Prompts

1\. "Explain the sorting and filtering rules for Nour Shelf stock alerts and how to implement visibleAlerts in a ChangeNotifier view model."

2\. "How do I perform Arabic string normalization in Dart to strip tatweel, short vowels, and normalize alef forms?"

3\. "Write PowerShell commands to create the layered directory structure for a Flutter project."



\## 3. AI Error and Resolution

The AI initially suggested sorting the internal private list in place within the getter. I identified this by reviewing the task requirement for list immutability, and corrected it by returning an unmodifiable list constructed from a sorted copy of the private list.



\## 4. Architecture Explanation

Placing visibleAlerts in the view model keeps sorting, filtering, and business logic decoupled from the UI widgets, allowing it to be tested in isolation with fast unit tests. This ensures that the screen widget remains a purely descriptive component that only listens to and renders state changes

