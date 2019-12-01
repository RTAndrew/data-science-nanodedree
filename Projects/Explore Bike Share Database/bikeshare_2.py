import time
import pandas as pd
import numpy as np
import datetime


CITY_DATA = { 'chicago': 'chicago.csv',
              'new york city': 'new_york_city.csv',
              'washington': 'washington.csv' }

month_types = ['January', 'February', 'March', 'April', 'May', 'June']
day_types = ['all', 'sun', 'mon', 'tue', 'wed', 'thur', 'fri', 'sat']
city_types = ['chicago', 'new york city', 'washington']

# Initialization to manipulate data throughout the file
now = datetime.datetime.now()


# Function to return the difference of time in seconds, 
# In various types of format such as day, hour, and minutes
def get_time_diff(time_in_second):
    diff_in_days    = divmod(time_in_second, 86400)               # Get days (without [0]!)
    diff_in_hours   = divmod(diff_in_days[1], 3600)               # Use remainder of days to calc hours
    diff_in_minutes = divmod(diff_in_hours[1], 60)                # Use remainder of hours to calc minutes
    diff_in_seconds = divmod(diff_in_minutes[1], 1)               # Use remainder of minutes to calc seconds
    
    print("{} days, {} hours, {} minutes and {} seconds" .format(diff_in_days[0], diff_in_hours[0], diff_in_minutes[0], diff_in_seconds[0]))

    
def get_filters():
    """
    Asks user to specify a city, month, and day to analyze.

    Returns:
        (str) city - name of the city to analyze
        (str) month - name of the month to filter by, or "all" to apply no month filter
        (str) day - name of the day of week to filter by, or "all" to apply no day filter
    """
    print('Hello! Let\'s explore some US bikeshare data!')
    
    
    # TO DO: get user input for city (chicago, new york city, washington). HINT: Use a while loop to handle invalid inputs
    print('What city would you like to explore (Chicago, New York, Washington)? ')
    city = input()
    city = city.lower()
    
    while city not in city_types:
        print('Please, introduce a City that corresponds to one of the following [Chicago, New York City, Washington]')
        city = input()
        city = city.lower()

    
    # TO DO: get user input for month (all, january, february, ... , june)
    print('Which month would you like to filter (All or Jan, Feb, Mar, Apr, May, Jun)? ')
    month = input()
    month = month.lower()
    
    
    # TO DO: get user input for day of week (all, monday, tuesday, ... sunday)
    print('Which day would you like to filter (All, Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday)? ')
    day = input()
    day = day.lower()
    
    print('-'*40)
    return city, month, day


def load_data(city, month, day):
    """
    Loads data for the specified city and filters by month and day if applicable.

    Args:
        (str) city - name of the city to analyze
        (str) month - name of the month to filter by, or "all" to apply no month filter
        (str) day - name of the day of week to filter by, or "all" to apply no day filter
    Returns:
        df - Pandas DataFrame containing city data filtered by month and day
    """
    
#   Check if the city exists
    for city_key, city_value in CITY_DATA.items():
        if city_key == city:
            df = pd.read_csv(city_value)
            #Filter dates
            df['Start Time'] = pd.to_datetime(df['Start Time'])
            df['month'] = df['Start Time'].dt.month
            df['day_of_week'] = df['Start Time'].dt.weekday_name
            break
    
    if month.lower() != 'all':
            # use the index of the months list to get the corresponding int
            months = ['jan', 'feb', 'mar', 'apr', 'may', 'jun']
            month = months.index(month) + 1
            df = df[df['month'] == month]
      
    if day != 'all':
            # use the index of the day list to get the corresponding int
            df = df[df['day_of_week'] == day.title()]
    
    return df


def time_stats(df):
    """Displays statistics on the most frequent times of travel."""

    print('\nCalculating The Most Frequent Times of Travel...\n')
    start_time = time.time()

    
    # TO DO: display the most common month
    most_common_month = df['month'].mode()[0]
    most_common_month = month_types[most_common_month - 1]
    print('The most common month is {}.' .format(most_common_month))

    
    # TO DO: display the most common day of week
    most_common_day = df['day_of_week'].mode()[0]
    print('The most common day is {}.' .format(most_common_day))
    
    
    # TO DO: display the most common start hour
    df['hour'] = df['Start Time'].dt.hour
    most_common_hour = df['hour'].mode()[0]
    print('The most common hour is {}.' .format(most_common_hour))

    print("\nThis took %s seconds." % (time.time() - start_time))
    print('-'*40)


def station_stats(df):
    """Displays statistics on the most popular stations and trip."""

    print('\nCalculating The Most Popular Stations and Trip...\n')
    start_time = time.time()

    
    # TO DO: display most commonly used start station
    most_common_start_station = df['Start Station'].mode()[0]
    print('The most common used Start Station is: {}.' .format(most_common_start_station))

    
    # TO DO: display most commonly used end station
    most_common_end_station = df['End Station'].mode()[0]
    print('The most common used End Station is: {}.' .format(most_common_end_station))

   
# TO DO: display most frequent combination of start station and end station trip
# For each row, there must be "Start-End Station"
# will be a concatenation of both Start Station and End Station
# Then, find the most commom occurence of the "Start-End Station"
    start_station = df['Start Station']
    end_station = df['End Station']
    df['Station Combination'] = start_station + ' and ' + end_station
    
    most_common_station_combination = df['Station Combination'].mode()[0]
    print('The most common used Station Combination is: {}.' .format(most_common_station_combination))
    
    print("\nThis took %s seconds." % (time.time() - start_time))
    print('-'*40)


def trip_duration_stats(df):
    """Displays statistics on the total and average trip duration."""

    print('\nCalculating Trip Duration...\n')
    start_time = time.time()

    # TO DO: display total travel time
    # convert the Start Time and End Time column to datetime
    df['Start Time'] = pd.to_datetime(df['Start Time'])
    df['End Time'] = pd.to_datetime(df['End Time'])
    time_diff_in_seconds = df['End Time'] - df['Start Time']
    
    #Convert the difference to seconds
    df['Total Time'] = time_diff_in_seconds.dt.seconds
    
    #Calculate the sum of total time of all rows
    total_travel_time = df['Total Time'].sum()
    
    print('\n The total travel time is: ')
    get_time_diff(total_travel_time)
    

    # TO DO: display mean travel time
    mean_travel_time = df['Total Time'].mean()
    print('\n The mean travel time is: ')
    get_time_diff(mean_travel_time)

    print("\nThis took %s seconds." % (time.time() - start_time))
    print('-'*40)


def user_stats(df):
    """Displays statistics on bikeshare users."""

    print('\nCalculating User Stats...\n')
    start_time = time.time()

    # TO DO: Display counts of user types
    user_types = df['User Type'].value_counts().to_string()
    print('According to our user types, we have: \n {} ' .format(user_types))
    
    # TO DO: Display counts of gender
    gender_distribution = df['Gender'].value_counts().to_string()
    print(' \n The distribution of gender is as it follows:  \n {}' .format(gender_distribution))
    
    # TO DO: Display earliest age most recent, and most common year of bi   
    print(' \n Regarding to the age of our bikers, we have:')
    earliest_birth_date = df['Birth Year'].min()
    earliest_birth_date = int(now.year - earliest_birth_date)
    print('- Oldest biker rider is {} years old' .format(earliest_birth_date))

    max_birth_date = df['Birth Year'].max()
    max_birth_date = int(now.year - max_birth_date)
    print('- Youngest biker rider is {} years old' .format(max_birth_date))

    common_birth_date = df['Birth Year'].mode()[0]
    common_birth_date = int(now.year - common_birth_date)
    print('- Common age of bikers is approximately {} years old' .format(common_birth_date))

    print("\nThis took %s seconds." % (time.time() - start_time))
    print('-'*40)


def main():
    while True:
        city, month, day = get_filters()
        df = load_data(city, month, day)

        time_stats(df)
        station_stats(df)
        trip_duration_stats(df)
        user_stats(df)

        restart = input('\nWould you like to restart? Enter yes or no.\n')
        if restart.lower() != 'yes':
            break


if __name__ == "__main__":
    main()
