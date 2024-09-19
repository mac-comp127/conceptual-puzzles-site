# Conceptual Mastery Puzzle web interface

Manages the COMP 127 Conceptual Mastery Puzzle process:

- Students can request official puzzle attempts.
- Instructors can enter grades for attempts.
- Students and instructors can view grading status for each puzzle type.


## Quick usage notes

Setup:

    rails db:create
    rails db:seed

Create local test data:

    rails db:fake:all

Run app in dev mode:

    bin/dev

    test_student_id=1 bin/dev  # fake user login in dev environment
