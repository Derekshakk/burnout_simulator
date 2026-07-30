# Team Assets

Each team member is represented by numbered files with the same number:

- `N.jpg` — photo (optional; a placeholder icon shows if the file is not supplied)
- `N.txt` — structured text in this exact format:

```
Name: Full Name Here
Role: Role / Title Here
Bio: One or two sentences describing this person's contribution to Project Ignite.
```

Text files must be numbered consecutively starting from 1 (1.txt, 2.txt, 3.txt …). The loader stops at the first missing text-file number. A photo, when supplied, must use the matching number (`N.jpg`).

**To add a new team member:** add `N.txt` and, if available, `N.jpg`, where N is the next available number. Run `flutter build web` to rebundle assets.

**To remove a team member:** remove that number's files and renumber any higher-numbered files to close the gap.
