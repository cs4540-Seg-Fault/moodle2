@gradingform @gradingform_rubric
Feature: Rubrics can be created and edited
  In order to use and refine rubrics to grade students
  As a teacher
  I need to edit previously used rubrics

  Background:
    Given the following "users" exists:
      | username | firstname | lastname | email |
      | teacher1 | Teacher | 1 | teacher1@asd.com |
      | student1 | Student | 1 | student1@asd.com |
    And the following "courses" exists:
      | fullname | shortname | format |
      | Course 1 | C1 | topics |
    And the following "course enrolments" exists:
      | user | course | role |
      | teacher1 | C1 | editingteacher |
      | student1 | C1 | student |
    And I log in as "teacher1"
    And I follow "Course 1"
    And I turn editing mode on
    And I add a "Assignment" to section "1" and I fill the form with:
      | Assignment name | Test assignment 1 name |
      | Description | Test assignment description |
      | Grading method | Rubric |
    When I go to "Test assignment 1 name" advanced grading definition page
    # Defining a rubric.
    And I fill the moodle form with:
      | Name | Assignment 1 rubric |
      | Description | Rubric test description |
    And I define the following rubric:
      | TMP Criterion 1 | TMP Level 11 | 11 | TMP Level 12 | 12 |
      | TMP Criterion 2 | TMP Level 21 | 21 | TMP Level 22 | 22 |
      | TMP Criterion 3 | TMP Level 31 | 31 | TMP Level 32 | 32 |
      | TMP Criterion 4 | TMP Level 41 | 41 | TMP Level 42 | 42 |
    # Checking that only the last ones are saved.
    And I define the following rubric:
      | Criterion 1 | Level 11 | 1 | Level 12 | 20 | Level 13 | 40 | Level 14 | 50 |
      | Criterion 2 | Level 21 | 10 | Level 22 | 20 | Level 23 | 30 |
      | Criterion 3 | Level 31 | 5 | Level 32 | 20 |
    And I press "Save as draft"
    And I go to "Test assignment 1 name" advanced grading definition page
    And I click on "Move down" "button" in the "Criterion 1" "table_row"
    And I press "Save rubric and make it ready"
    Then I should see "Ready for use"
    # Grading two students.
    And I go to "Student 1" "Test assignment 1 name" activity advanced grading page
    And I grade by filling the rubric with:
      | Criterion 1 | 50 | Very good |
    And I press "Save changes"
    # Checking that it complains if you don't select a level for each criterion.
    And I should see "Please choose something for each criterion"
    And I grade by filling the rubric with:
      | Criterion 1 | 50 | Very good |
      | Criterion 2 | 10 | Mmmm, you can do it better |
      | Criterion 3 | 5 | Not good |
    And I complete the advanced grading form with these values:
      | Feedback comments | In general... work harder... |
    # Checking that the user grade is correct.
    And I should see "58.33" in the "Student 1" "table_row"
    # Updating the user grade.
    And I go to "Student 1" "Test assignment 1 name" activity advanced grading page
    And I grade by filling the rubric with:
      | Criterion 1 | 20 | Bad, I changed my mind |
      | Criterion 2 | 10 | Mmmm, you can do it better |
      | Criterion 3 | 5 | Not good |
    #And the level with "50" points was previously selected for the rubric criterion "Criterion 1"
    #And the level with "20" points is selected for the rubric criterion "Criterion 1"
    And I save the advanced grading form
    And I should see "22.62" in the "Student 1" "table_row"
    And I log out
    # Viewing it as a student.
    And I log in as "student1"
    And I follow "Course 1"
    And I follow "Test assignment 1 name"
    And I should see "22.62" in the ".feedback" "css_element"
    And I should see "Rubric test description" in the ".feedback" "css_element"
    And I should see "In general... work harder..."
    And the level with "10" points is selected for the rubric criterion "Criterion 2"
    And the level with "20" points is selected for the rubric criterion "Criterion 1"
    And the level with "5" points is selected for the rubric criterion "Criterion 3"
    And I log out
    And I log in as "teacher1"
    And I follow "Course 1"
    # Editing a rubric definition without regrading students.
    And I go to "Test assignment 1 name" advanced grading definition page
    And "Save as draft" "button" should not exists
    And I click on "Move up" "button" in the "Criterion 1" "table_row"
    And I replace "Level 11" rubric level with "Level 11 edited" in "Criterion 1" criterion
    And I press "Save"
    And I should see "You are about to save changes to a rubric that has already been used for grading."
    And I select "Do not mark for regrade" from "menurubricregrade"
    And I press "Continue"
    And I log out
    # Check that the student still sees the grade.
    And I log in as "student1"
    And I follow "Course 1"
    And I follow "Test assignment 1 name"
    And I should see "22.62" in the ".feedback" "css_element"
    And the level with "20" points is selected for the rubric criterion "Criterion 1"
    And I log out
    # Editing a rubric with significant changes.
    And I log in as "teacher1"
    And I follow "Course 1"
    And I go to "Test assignment 1 name" advanced grading definition page
    And I click on "Move down" "button" in the "Criterion 2" "table_row"
    And I replace "1" rubric level with "11" in "Criterion 1" criterion
    And I press "Save"
    And I should see "You are about to save significant changes to a rubric that has already been used for grading. The gradebook value will be unchanged, but the rubric will be hidden from students until their item is regraded."
    And I press "Continue"
    And I log out
    # Check that the student doesn't see the grade.
    And I log in as "student1"
    And I follow "Course 1"
    And I follow "Test assignment 1 name"
    And I should see "22.62" in the ".feedback" "css_element"
    And the level with "20" points is not selected for the rubric criterion "Criterion 1"
    And I log out
    # Regrade student.
    And I log in as "teacher1"
    And I follow "Course 1"
    And I follow "Test assignment 1 name"
    And I go to "Student 1" "Test assignment 1 name" activity advanced grading page
    And I should see "The rubric definition was changed after this student had been graded. The student can not see this rubric until you check the rubric and update the grade."
    And I save the advanced grading form
    And I log out
    # Check that the student sees the grade again.
    And I log in as "student1"
    And I follow "Course 1"
    And I follow "Test assignment 1 name"
    And I should see "12.16" in the ".feedback" "css_element"
    And the level with "20" points is not selected for the rubric criterion "Criterion 1"
    # Hide all rubric info for students
    And I log out
    And I log in as "teacher1"
    And I follow "Course 1"
    And I go to "Test assignment 1 name" advanced grading definition page
    And I uncheck "Allow users to preview rubric used in the module (otherwise rubric will only become visible after grading)"
    And I uncheck "Display rubric description during evaluation"
    And I uncheck "Display rubric description to those being graded"
    And I uncheck "Display points for each level during evaluation"
    And I uncheck "Display points for each level to those being graded"
    And I press "Save"
    And I select "Do not mark for regrade" from "menurubricregrade"
    And I press "Continue"
    And I log out
    # Students should not see anything.
    And I log in as "student1"
    And I follow "Course 1"
    And I follow "Test assignment 1 name"
    And I should not see "Criterion 1" in the ".submissionstatustable" "css_element"
    And I should not see "Criterion 2" in the ".submissionstatustable" "css_element"
    And I should not see "Criterion 3" in the ".submissionstatustable" "css_element"
    And I should not see "Rubric test description" in the ".feedback" "css_element"

  @javascript
  Scenario: I can use rubrics to grade and edit them later updating students grades with Javascript enabled

  Scenario: I can use rubrics to grade and edit them later updating students grades with Javascript disabled
