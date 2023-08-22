# Contributing

All contributes are always welcome.
That said, we require some guidelines to be followed, in order for PRs to be merged.

> The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL
> NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED",  "MAY", and
> "OPTIONAL" in this document are to be interpreted as described in
> RFC 2119.

## Before Contributing

- For **bugfixes** only, you MUST open a new [**issue**](https://github.com/sbertix/SystemImagePicker/issues), if one on the topic does not exist already, before submitting your pull request.
   - You SHOULD rely on provided issue templates.
- For **enhancements** only, you SHOULD open a new [**discussion**](https://github.com/sbertix/SystemImagePicker/discussions), if one on the topic does not exist already, before submitting your pull request.
   - Discussions for small additive implementations are OPTIONAL.
   - Discussions for breaking changes are REQUIRED.
   - Wait for feedback before embarking on time-consuming projects.
   - Understand that consistency _always_ comes first.

## When Writing your Code

- You MUST write your code so that it runs on `Swift 5.8`.
- You MUST lint your code using [`swiftlint`](https://github.com/realm/SwiftLint).

## When Contributing

- Your commits SHOULD be [signed](https://docs.github.com/en/github/authenticating-to-github/managing-commit-signature-verification/signing-commits).
   - **Commits pushing new features and CI implementations MUST be signed**.
   - Commits pushing bugfixes SHOULD be signed.
   - Other commits MAY be signed.
- You SHOULD open `draft` pull requests as soon as you start working on them, in order to let the community know of your plans and avoid duplication.
- **Pull requests SHOULD only solve one problem: stick to the minimal set of changes**.
- New code SHOULD come with new tests.
- **Pull requests MUST always target `main` latest commit**.
- Pull requests SHOULD have a linear commit history.
- You SHOULD ask for a review as soon as you are done with your changes.
