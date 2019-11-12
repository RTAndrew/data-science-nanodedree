names =  ['Anderson', 'Samara', 'John']
assignments =  [8, 5, 7]
grades =  [8.1, 10, 7.8]

# message string to be used for each student
# HINT: use .format() with this string in your for loop



message = "Hi {},\n\nThis is a reminder that you have {} assignments left to \
submit before you can graduate. You're current grade is {} and can increase \
to {} if you submit all assignments before the due date.\n\n"

lista = list(zip(names, assignments, grades))

for name, assignment, grade in zip(names, assignments, grades):
	print(message.format(name, assignment, grade, int(grade) + int(assignment)*2))