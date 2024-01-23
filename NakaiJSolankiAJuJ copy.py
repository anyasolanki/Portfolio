'''
    Team NakaiJSolankiAJuJ
    CS3200 - Final Project 
    Topic: Rate My Co-op 
    Database name: rmc 
'''

import mysql.connector
import matplotlib.pyplot as plt


username = input("\nEnter MySQL username: ")
password = input("Enter MySQL password: ")

# Establish MySQL connection
cnx = mysql.connector.connect(
    host="localhost",
    user=username,
    password=password,
    database="rmc"
)
cursor = cnx.cursor()

# Function to prompt user for sign-up details
def signup():
    print("\nSign Up")
    first_name = input("Enter your first name: ")
    last_name = input("Enter your last name: ")
    student_id = input("Enter your student ID: ")
    graduation_year = input("Enter your graduation year: ")
    university_name = input("Enter your university's associated ID: ")
    major = input("Enter your major: ")
   

    # Save user details to the database
    query = "INSERT INTO student (first_name, last_name, student_id, grad_year, school_attending, major) VALUES (%s, %s, %s, %s, %s, %s)"
    values = (first_name, last_name, student_id, graduation_year, university_name, major)

    try:
        cursor.execute(query, values)
        cnx.commit()
        print("Sign up successful!")
    except mysql.connector.Error as err:
        print("Error signing up:", err)

# Function to handle student-company review
def student_company_review():
    print("\nStudent-Company Review")

    while True:
        print("1. Make a Review")
        print("2. Edit a Review")
        print("3. Read Reviews")
        print("4. Go back to the main menu")

        choice = input("Enter your choice: ")

        if choice == "1":
            # Make a review
            location_rating = int(input("\nEnter location rating (1-10): "))
            facilities_rating = int(input("Enter facilities rating (1-10): "))
            work_environment_rating = int(input("Enter work environment rating (1-10): "))
            food_rating = int(input("Enter food rating (1-10): "))
            safety_rating = int(input("Enter safety rating (1-10): "))
            community_rating = int(input("Enter community rating (1-10): "))
            overall_rating = int(input("Enter overall rating (1-10): "))
            comments = input("Add your comments: ")
            
            # Add the review to the database
            query = "INSERT INTO student_company_review (location_rating, facilities_rating, work_env_rating, food_rating, safety_rating, community_rating, overall_rating, comments) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)"
            values = (location_rating, facilities_rating, work_environment_rating, food_rating, safety_rating, community_rating, overall_rating, comments)

            try:
                cursor.execute(query, values)
                cnx.commit()
                print("Review added successfully!\n")
            except mysql.connector.Error as err:
                print("Error adding review:", err)

        elif choice == "2":
            # Edit a review
            # Show a list of reviews from the database
            query = "SELECT * FROM student_company_review"
            cursor.execute(query)
            reviews = cursor.fetchall()

            print("\nSelect a review to edit:")
            for review in reviews:
                print(f"Review ID: {review[0]}")

            review_id = input("Enter the review ID: ")

            # Check if the review exists
            query = "SELECT * FROM student_company_review WHERE company_rev_id = %s"
            values = (review_id,)
            cursor.execute(query, values)
            review = cursor.fetchone()

            if review:
                delete_choice = input("Do you want to delete this review? (yes/no): ")
                if delete_choice.lower() == "yes":
                    # Delete the review from the database
                    query = "DELETE FROM student_company_review WHERE company_rev_id = %s"
                    values = (review_id,)
                    cursor.execute(query, values)
                    cnx.commit()
                    print("Review deleted successfully!\n")
                else:
                    # Prompt for revision
                    revision = input("Enter the revision for the comments: ")

                    # Update the review in the database
                    query = "UPDATE student_company_review SET comments = %s WHERE company_rev_id = %s"
                    values = (revision, review_id)
                    cursor.execute(query, values)
                    cnx.commit()
                    print("Review revised successfully!")
                    
                    # Retrieve and print the updated review
                    query = "SELECT * FROM student_company_review WHERE company_rev_id = %s"
                    values = (review_id,)
                    cursor.execute(query, values)
                    updated_review = cursor.fetchone()
                    print("Updated Review: \n")
                    print(updated_review)
            else:
                print("Review not found!\n")

        elif choice == "3":
            # Read reviews
            query = "SELECT * FROM student_company_review"
            cursor.execute(query)
            reviews = cursor.fetchall()
            
            
            if len(reviews) > 0:
                print("\nStudent-Company Reviews:")
                for review in reviews:
                    print(f"Review ID: {review[0]}")
                
                
                # Call the overall ratings visualization function
                visualize_overall_ratings()
                
                while True:
                    review_id = int(input("Enter the review ID: "))
        
                    selected_review = None
                    for review in reviews:
                        if review[0] == review_id:
                            selected_review = review
                            break
        
                    if selected_review:
                        print("\nSelected Review:")
                        print(f"Review ID: {selected_review[0]}")
                        print(f"Location Rating: {selected_review[3]}")
                        print(f"Facilities Rating: {selected_review[4]}")
                        print(f"Work Environment Rating: {selected_review[5]}")
                        print(f"Food Rating: {selected_review[6]}")
                        print(f"Safety Rating: {selected_review[7]}")
                        print(f"Community Rating: {selected_review[8]}")
                        print(f"Overall Rating: {selected_review[9]}")
                        print(f"Comments: {selected_review[10]}")
                        break
                    else:
                        print("Invalid review ID. Please try again.")
    
                if len(reviews) == 0:
                    print("No reviews found!")
            
            go_back = input("\nPress 'yes' to go back to the main menu: ")
            if go_back.lower() == "yes":
                break

        elif choice == "4":
            # Go back to the main menu
            break

        else:
            print("Invalid choice. Please try again.")

    print("\nReturning to the main menu...")


def student_interview_review():
    print("\nStudent-Interview Review")

    while True:
        print("1. Make a Review")
        print("2. Edit a Review")
        print("3. Read Reviews")
        print("4. Go back to the main menu")

        choice = input("Enter your choice: ")

        if choice == "1":
            # Make a review
            difficulty_rating = int(input("\nEnter difficulty rating (1-10): "))
            casual_rating = int(input("Enter casual rating (1-10): "))
            length_rating = int(input("Enter length rating (1-10): "))
            overall_rating = int(input("Enter overall rating (1-10): "))
            comments = input("Add your comments: ")

            # Add the review to the database
            query = "INSERT INTO student_interview_review (difficulty_rating, casual_rating, length, overall_rating, comments) VALUES (%s, %s, %s, %s, %s)"
            values = (difficulty_rating, casual_rating, length_rating, overall_rating, comments)

            try:
                cursor.execute(query, values)
                cnx.commit()
                print("Review added successfully!")
            except mysql.connector.Error as err:
                print("Error adding review:", err)

        elif choice == "2":
            # Edit a review
            # Show a list of reviews from the database
            query = "SELECT * FROM student_interview_review"
            cursor.execute(query)
            reviews = cursor.fetchall()

            print("\nSelect a review to edit:")
            for review in reviews:
                print(f"Review ID: {review[0]}")

            review_id = input("Enter the review ID: ")

            # Check if the review exists
            query = "SELECT * FROM student_interview_review WHERE interview_id = %s"
            values = (review_id,)
            cursor.execute(query, values)
            review = cursor.fetchone()

            if review:
                delete_choice = input("Do you want to delete this review? (yes/no): ")
                if delete_choice.lower() == "yes":
                    # Delete the review from the database
                    query = "DELETE FROM student_interview_review WHERE interview_id = %s"
                    values = (review_id,)
                    cursor.execute(query, values)
                    cnx.commit()
                    print("Review deleted successfully!")
                else:
                    # Prompt for revision
                    revision = input("Enter the revision for the comments: ")

                    # Update the review in the database
                    query = "UPDATE student_interview_review SET comments = %s WHERE interview_id = %s"
                    values = (revision, review_id)
                    cursor.execute(query, values)
                    cnx.commit()
                    print("Review revised successfully!")
                    
                    # Retrieve and print the updated review
                    query = "SELECT * FROM student_interview_review WHERE interview_id = %s"
                    values = (review_id,)
                    cursor.execute(query, values)
                    updated_review = cursor.fetchone()
                    print("Updated Review:")
                    print(updated_review)
            else:
                print("Review not found!")

        elif choice == "3":
            # Read reviews
            query = "SELECT * FROM student_interview_review"
            cursor.execute(query)
            reviews = cursor.fetchall()
            
            if len(reviews) > 0:
                print("\nStudent-Interview Reviews:")
            for review in reviews:
                print(f"Review ID: {review[0]}")
                
            # Call the visualization function
            visualize_difficulty_ratings()

            while True:
                review_id = int(input("Enter the review ID: "))
        
                selected_review = None
                for review in reviews:
                    if review[0] == review_id:
                        selected_review = review
                        break
        
                if selected_review:
                    print("\nSelected Review:")
                    print(f"Review ID: {selected_review[0]}")
                    print(f"Company Rating: {selected_review[3]}")
                    print(f"Interview Experience Rating: {selected_review[4]}")
                    print(f"Interview Questions Rating: {selected_review[5]}")
                    print(f"Interview Difficulty Rating: {selected_review[6]}")
                    print(f"Overall Rating: {selected_review[7]}")
                    print(f"Comments: {selected_review[8]}")
                    break
                else:
                    print("Invalid review ID. Please try again.")
    
            if len(reviews) == 0:
                print("No reviews found!")

            go_back = input("\nPress 'yes' to go back to the main menu: ")
            if go_back.lower() == "yes":
                break

        elif choice == "4":
            # Go back to the main menu
            break

        else:
            print("Invalid choice. Please try again.")

    print("\nReturning to the main menu...")


def student_position_review():
    print("\nStudent-Position Review")

    while True:
        print("1. Make a Review")
        print("2. Edit a Review")
        print("3. Read Reviews")
        print("4. Go back to the main menu")

        choice = input("Enter your choice: ")

        if choice == "1":
            # Make a review
            boss_rating = int(input("\nEnter Boss/Supervisor rating (1-10): "))
            colleague_rating = int(input("Enter colleague rating (1-10): "))
            collaborative_rating = int(input("Enter collaborative rating (1-10): "))
            pay_satisfaction_rating = int(input("Enter pay satisfaction rating (1-10): "))
            productivity_rating = int(input("Enter productivity rating (1-10): "))
            satisfaction_rating = int(input("Enter satisfaction rating (1-10): "))
            overall_rating = int(input("Enter overall rating (1-10): "))
            comments = input("Add your comments: ")

            # Add the review to the database
            query = "INSERT INTO student_position_review (supervisor_rating, colleague_rating, collaborative_rating, pay_satisfaction_rating, productivity_rating, satisfaction_rating, overall_rating, comments) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)"
            values = (boss_rating, colleague_rating, collaborative_rating, pay_satisfaction_rating, productivity_rating, satisfaction_rating, overall_rating, comments)

            try:
                cursor.execute(query, values)
                cnx.commit()
                print("Review added successfully!")
            except mysql.connector.Error as err:
                print("Error adding review:", err)

        elif choice == "2":
            # Edit a review
            # Show a list of reviews from the database
            query = "SELECT * FROM student_position_review"
            cursor.execute(query)
            reviews = cursor.fetchall()

            print("\nSelect a review to edit:")
            for review in reviews:
                print(f"Review ID: {review[0]}")

            review_id = input("Enter the review ID: ")

            # Check if the review exists
            query = "SELECT * FROM student_position_review WHERE position_rev_id = %s"
            values = (review_id,)
            cursor.execute(query, values)
            review = cursor.fetchone()

            if review:
                delete_choice = input("Do you want to delete this review? (yes/no): ")
                if delete_choice.lower() == "yes":
                    # Delete the review from the database
                    query = "DELETE FROM student_position_review WHERE position_rev_id = %s"
                    values = (review_id,)
                    cursor.execute(query, values)
                    cnx.commit()
                    print("Review deleted successfully!")
                else:
                    # Prompt for revision
                    revision = input("Enter the revision for the comments: ")

                    # Update the review in the database
                    query = "UPDATE student_position_review SET comments = %s WHERE position_rev_id = %s"
                    values = (revision, review_id)
                    cursor.execute(query, values)
                    cnx.commit()
                    print("Review revised successfully!")
                    
                    # Retrieve and print the updated review
                    query = "SELECT * FROM student_position_review WHERE position_rev_id = %s"
                    values = (review_id,)
                    cursor.execute(query, values)
                    updated_review = cursor.fetchone()
                    print("Updated Review:")
                    print(updated_review)
            else:
                print("Review not found!")

        elif choice == "3":
            # Read reviews
            query = "SELECT * FROM student_position_review"
            cursor.execute(query)
            reviews = cursor.fetchall()

            if len(reviews) > 0:
                print("\nStudent-Position Reviews:")
            for review in reviews:
                print(f"Review ID: {review[0]}")
            
            # Visualize pay satisfaction ratings
            visualize_pay_satisfaction_ratings()
            
            while True:
                review_id = int(input("Enter the review ID: "))
        
                selected_review = None
                for review in reviews:
                    if review[0] == review_id:
                        selected_review = review
                        break
        
                if selected_review:
                    print("\nSelected Review:")
                    print(f"Review ID: {selected_review[0]}")
                    print(f"Supervisor Rating: {selected_review[5]}")
                    print(f"Colleague Rating: {selected_review[6]}")
                    print(f"Collaborative Rating: {selected_review[7]}")
                    print(f"Pay Satisfaction Rating: {selected_review[8]}")
                    print(f"Productivity Rating: {selected_review [9]}")
                    print(f"Satisfaction Rating: {selected_review[10]}")
                    print(f"Overall Rating: {selected_review[11]}")
                    print(f"Comments: {selected_review[12]}")
                    break
                else:
                    print("Invalid review ID. Please try again.")
    
            if len(reviews) == 0:
                print("No reviews found!")
        
        go_back = input("\nPress 'yes' to go back to the main menu: ")
        if go_back.lower() == "yes":
            break

        elif choice == "4":
            # Go back to the main menu
            break

        else:
            print("Invalid choice. Please try again.")

    print("\nReturning to the main menu...")

def visualize_overall_ratings():
    # Retrieve overall ratings from the database
    query = "SELECT overall_rating FROM student_company_review"
    cursor.execute(query)
    overall_ratings = cursor.fetchall()

    # Prepare data for visualization
    ratings_count = {}
    for rating in overall_ratings:
        if rating[0] in ratings_count:
            ratings_count[rating[0]] += 1
        else:
            ratings_count[rating[0]] = 1

    # Create a pie chart
    labels = list(ratings_count.keys())
    counts = list(ratings_count.values())
    plt.pie(counts, labels=labels, autopct='%1.1f%%')
    plt.title("Distribution of Overall Ratings")
    plt.show()

def visualize_difficulty_ratings():
    # Retrieve difficulty ratings from the database
    query = "SELECT difficulty_rating FROM student_interview_review"
    cursor.execute(query)
    difficulty_ratings = cursor.fetchall()

    # Prepare data for visualization
    ratings = [rating[0] for rating in difficulty_ratings]

    # Create a histogram
    plt.hist(ratings, bins=10, edgecolor='black')
    plt.xlabel("Difficulty Rating")
    plt.ylabel("Frequency")
    plt.title("Distribution of Difficulty Ratings")
    plt.show()

def visualize_pay_satisfaction_ratings():
    query = "SELECT pay_satisfaction_rating FROM student_position_review"
    cursor.execute(query)
    results = cursor.fetchall()

    ratings = []

    if len(results) > 0:
        for result in results:
            rating = result[0]
            ratings.append(rating)

        # Plot the bar chart
        plt.bar(range(len(ratings)), ratings)
        plt.xlabel("Review ID")
        plt.ylabel("Pay Satisfaction Rating")
        plt.title("Pay Satisfaction Ratings per Review")
        plt.xticks(range(len(ratings)))
        plt.show()
    else:
        print("No pay satisfaction ratings found.")


# Main program loop
def main_menu():
    while True:
        print("\nMain Menu")
        print("1. Student-Company Review")
        print("2. Student-Interview Review")
        print("3. Student-Position Review")
        print("4. Exit")
        choice = input("Enter your choice: ")

        if choice == "1":
            student_company_review()
        elif choice == "2":
            student_interview_review()
        elif choice == "3":
            student_position_review()
        elif choice == "4":
            break
        else:
            print("Invalid choice. Please try again.")

# Entry point of the program
def run_program():
    print("\nWelcome to the Rate My Co-op Program!")

    # Check if the user is a member or not
    is_member = input("\nAre you a member? (yes/no): ")
    if is_member.lower() == "yes":
        main_menu()
    elif is_member.lower() == "no":
        signup()
        main_menu()
    else:
        print("Invalid choice. Please try again.")

    # Close the MySQL connection
    cursor.close()
    cnx.close()

# Run the program
run_program()

