import 'dart:math';

import 'figures.dart';

class Question {
  const Question({
    required this.category,
    required this.prompt,
    required this.options,
    required this.correctIndex,
    this.figure,
    this.optionArts = const [],
  });

  final String category;
  final String prompt;
  final List<String> options;
  final int correctIndex;
  final Art? figure;
  final List<Art?> optionArts;

  String get correctAnswer => options[correctIndex];

  Art? artForOption(int index) {
    if (index < 0 || index >= optionArts.length) return null;
    return optionArts[index];
  }
}

/// 13 topics need one question each. Two more are drawn from the rest, so
/// every quiz is 15 questions and still covers every topic.
const int quizSize = 15;
const int questionsPerCategory = 1;

List<Question> pickQuiz(List<Question> bank, Random random) {
  final grouped = <String, List<Question>>{};
  for (final question in bank) {
    grouped.putIfAbsent(question.category, () => []).add(question);
  }

  final selected = <Question>[];
  final used = <Question>{};
  for (final questions in grouped.values) {
    final copy = List<Question>.of(questions)..shuffle(random);
    final taken = copy.take(min(questionsPerCategory, copy.length));
    selected.addAll(taken);
    used.addAll(taken);
  }

  final rest = bank.where((question) => !used.contains(question)).toList()..shuffle(random);
  final extra = quizSize - selected.length;
  if (extra > 0) selected.addAll(rest.take(extra));
  selected.shuffle(random);
  return selected;
}

const List<String> categories = [
  'Science and Technology',
  'Language and Literature',
  'Health and Hygiene',
  'Environmental Science',
  'Sports and Physical Fitness',
  'Religion, Culture, Tradition and Our Epics',
  'Politics and Governance',
  'Jobs and Careers',
  'Food and Beverages',
  'Computer Applications',
  'Current Affairs',
  'Mathematics',
  'Aptitude, Analytical, Critical Thinking and Logical Reasoning',
];

Question _q(
  String category,
  String prompt,
  List<String> options,
  int correct, {
  Art? figure,
  List<Art?> optionArts = const [],
}) {
  return Question(
    category: category,
    prompt: prompt,
    options: options,
    correctIndex: correct,
    figure: figure,
    optionArts: optionArts,
  );
}

final List<Question> questionBank = [
  ..._science,
  ..._language,
  ..._health,
  ..._environment,
  ..._sports,
  ..._religion,
  ..._politics,
  ..._jobs,
  ..._food,
  ..._computer,
  ..._currentAffairs,
  ..._math,
  ..._aptitude,
];

final List<Question> _science = [
  _q('Science and Technology', 'How many planets are there in our solar system?', ['7', '8', '10', '5'], 1),
  _q('Science and Technology', 'Which is the strongest bone in our body?', ['Arm bone', 'Thigh bone', 'Skull', 'Elbow'], 1),
  _q('Science and Technology', 'Which is the fastest means of transport?', ['Bus', 'Train', 'Aeroplane', 'Ship'], 2),
  _q('Science and Technology', 'Which part of the body is shaped like rajma beans?', ['Lungs', 'Kidney', 'Liver', 'Intestine'], 1),
  _q('Science and Technology', "Which planet is also known as the 'Red Planet'?", ['Jupiter', 'Mars', 'Mercury', 'Earth'], 1),
  _q('Science and Technology', 'Which one of these will a magnet pick up?', ['Plastic ruler', 'Balloon', 'Iron nail', 'Piece of paper'], 2),
  _q('Science and Technology', 'What is ice made of?', ['Paneer', 'Juice', 'Milk', 'Water'], 3),
  _q('Science and Technology', 'Which organ pumps blood to our body?', ['Lungs', 'Kidney', 'Heart', 'Brain'], 2),
  _q('Science and Technology', 'Which appliance keeps our food fresh?', ['Vacuum cleaner', 'Mobile phone', 'Refrigerator', 'All of these'], 2),
  _q('Science and Technology', 'Which one of these helps us to talk to people far away?', ['Spoon', 'Chair', 'Telephone', 'Book'], 2),
];

final List<Question> _language = [
  _q('Language and Literature', 'When we cut a fruit into two equal parts, what do we get?', ['Three pieces', 'Two halves', 'Four pieces', 'None of these'], 1),
  _q('Language and Literature', 'What is a book used to make a daily record called?', ['Album', 'Card', 'Calendar', 'Diary'], 3),
  _q('Language and Literature', 'How many consonants are there in the English alphabet?', ['20', '21', '23', '25'], 1),
  _q('Language and Literature', 'Which one is different from the others?', ['Teacher', 'Doctor', 'Pilot', 'Monkey'], 3),
  _q('Language and Literature', "What is the opposite of 'sharp'?", ['Blunt', 'Pointed', 'Crisp', 'Knife'], 0),
  _q('Language and Literature', 'India ________ developing fast.', ['was', 'is', 'are', 'am'], 1),
  _q('Language and Literature', 'Fill in the blanks: She is good ________ painting.', ['on', 'with', 'from', 'at'], 3),
  _q('Language and Literature', 'Lemons are ________. (Fill in the blank with an adjective)', ['spicy', 'sour', 'sweet', 'bitter'], 1),
  _q('Language and Literature', 'Who found the magic lamp?', ['Aladdin', 'Princess Jasmine', 'Genie', 'Jafar'], 0),
  _q('Language and Literature', 'Which of the following is correctly spelt?', ['Competition', 'Compitione', 'Compitetion', 'Competetion'], 0),
];

final List<Question> _health = [
  _q('Health and Hygiene', 'What is the usual colour of a carrot?', ['Blue', 'Green', 'Purple', 'Orange'], 3),
  _q('Health and Hygiene', 'When is it not necessary to wash your hands?', ['Before eating', 'After eating', 'Both a and b', 'After bathing'], 3),
  _q('Health and Hygiene', 'What do you take when you fall ill?', ['Food', 'Medicine', 'Water', 'Sweets'], 1),
  _q('Health and Hygiene', 'We should never play with:', ['Teddy bear', 'Knife', 'Ball', 'Video game'], 1),
  _q('Health and Hygiene', 'Clove oil is used for relieving which of the following?', ['Toothache', 'Headache', 'Muscle pain', 'All of these'], 3),
  _q('Health and Hygiene', 'Which type of clothes should we wear?', ['Clean', 'Dirty', 'Wet', 'Faded'], 0),
  _q('Health and Hygiene', 'What should we do to our hair daily?', ['Trim', 'Not oil', 'Comb', 'Not comb'], 2),
  _q('Health and Hygiene', 'What is the approximate percentage of water in our body?', ['50%', '60%', '80%', '25%'], 1),
  _q('Health and Hygiene', 'What is dangerous to touch with wet hands?', ['Toys', 'Knife', 'Gas stove', 'Electric switch'], 3),
  _q('Health and Hygiene', 'Radha is a student. What should she eat to stay healthy and strong?', ['Healthy and nutritious food', 'Junk food', 'Frozen meals', 'All of these'], 0),
];

final List<Question> _environment = [
  _q('Environmental Science', 'What causes pollution?', ['Trees', 'Animals', 'Flowers', 'Factories'], 3),
  _q('Environmental Science', 'What is a large earthquake that occurs underneath the ocean called?', ['Volcano', 'Tsunami', 'Earthquake', 'Food'], 1),
  _q('Environmental Science', 'In how many forms does water exist?', ['1', '2', '3', 'None of these'], 2),
  _q('Environmental Science', 'What is the colour of the sun during sunrise and sunset?', ['Orange', 'Yellow', 'Blue', 'White'], 0),
  _q('Environmental Science', 'What type of tree do dates grow on?', ['Coconut', 'Pine', 'Palm', 'Birch'], 2),
  _q('Environmental Science', 'What is the rainy season called in India?', ['Autumn', 'Spring', 'Monsoon', 'Sunshine'], 2),
  _q('Environmental Science', 'What do animals need to stay alive?', ['Water and air', 'Air only', 'Water only', 'Food, water and air'], 3),
  _q('Environmental Science', 'Which type of clothes do we wear in the summer season?', ['Woollen', 'Cotton', 'Silk', 'Polyester'], 1),
  _q('Environmental Science', 'If a man is shouting, how is the sound he makes?', ['Quiet', 'Silent', 'Loud', 'Soft'], 2),
  _q('Environmental Science', 'Herbivores eat only plants. Which of the following animals is a herbivore?', ['Fox', 'Sheep', 'Eagle', 'Tiger'], 1),
];

final List<Question> _sports = [
  _q('Sports and Physical Fitness', 'Which of the following is not an outdoor game?', ['Cricket', 'Football', 'Hockey', 'Table tennis'], 3),
  _q('Sports and Physical Fitness', 'What is the original name of table tennis?', ['Ping Pong', 'Soccer', 'Googley', 'Checkmate'], 0),
  _q('Sports and Physical Fitness', 'How do games affect our health?', ['Keep us fit', 'Keep us healthy', 'Make us sick', 'Both a and b'], 3),
  _q('Sports and Physical Fitness', 'How many players are there in a cricket team?', ['6', '8', '4', '11'], 3),
  _q('Sports and Physical Fitness', 'From which country did volleyball originate?', ['China', 'Europe', 'India', 'USA'], 3),
  _q('Sports and Physical Fitness', 'Which is the National Game of China?', ['Badminton', 'Archery', 'Table Tennis', 'Judo'], 2),
  _q('Sports and Physical Fitness', 'What are games that we play inside buildings called?', ['Outdoor games', 'Indoor games', 'Fun games', 'None of these'], 1),
  _q('Sports and Physical Fitness', 'How many players are there in a hockey team?', ['11', '6', '4', '9'], 0),
  _q('Sports and Physical Fitness', 'Which game does Viswanathan Anand play?', ['Chess', 'Carrom', 'Kabaddi', 'Cricket'], 0),
  _q('Sports and Physical Fitness', 'Which is the biggest sporting event organized in the world?', ['Olympic Games', 'International Games', 'National Games', 'Indo-Asia Games'], 0),
];

final List<Question> _religion = [
  _q('Religion, Culture, Tradition and Our Epics', 'Which festival is called the Festival of Lights?', ['Dussehra', 'Ugadi', 'Onam', 'Diwali'], 3),
  _q('Religion, Culture, Tradition and Our Epics', 'What colour symbolizes peace?', ['Green', 'White', 'Saffron', 'Red'], 1),
  _q('Religion, Culture, Tradition and Our Epics', 'How many times do Muslims offer Namaz in a day?', ['2 times', '3 times', '4 times', '5 times'], 3),
  _q('Religion, Culture, Tradition and Our Epics', 'What does the saffron colour in our National Flag signify?', ['Peace', 'Prosperity', 'Progress', 'Sacrifice'], 3),
  _q('Religion, Culture, Tradition and Our Epics', 'Find the odd one out from the following:', ['Dhoti', 'Turban', 'Lungi', 'Pyjama'], 1),
  _q('Religion, Culture, Tradition and Our Epics', 'When do Christians celebrate Christmas?', ['28th of December', '26th of December', '27th of December', '25th of December'], 3),
  _q('Religion, Culture, Tradition and Our Epics', 'Which is the important festival of Muslims?', ['Eid-e-Milad', 'Diwali', 'Pongal', 'Christmas'], 0),
  _q('Religion, Culture, Tradition and Our Epics', 'Which festival is mainly celebrated in Kerala?', ['Lohri', 'Gurupurab', 'Christmas', 'Onam'], 3),
  _q('Religion, Culture, Tradition and Our Epics', 'Why do we touch the feet of elders?', ['To play', 'To say goodbye', 'To show respect', 'To ask for food'], 2),
  _q('Religion, Culture, Tradition and Our Epics', 'Kuchipudi is the classical dance form of which Indian state?', ['Tamil Nadu', 'Kerala', 'Andhra Pradesh', 'Karnataka'], 2),
];

final List<Question> _politics = [
  _q('Politics and Governance', 'What is the name of the country where we live?', ['America', 'India', 'Canada', 'Australia'], 1),
  _q('Politics and Governance', 'What do we call people who vote in an election?', ['Citizens', 'Animals', 'Children', 'Teachers'], 0),
  _q('Politics and Governance', 'What was Mother Teresa known for?', ['Anger', 'Kindness', 'Strength', 'Fear'], 1),
  _q('Politics and Governance', 'Who helps make and follow the rules of the country?', ['Students', 'Government', 'Animals', 'Police'], 1),
  _q('Politics and Governance', 'Who is the head of our country?', ['Teacher', 'President', 'Father', 'Farmer'], 1),
  _q('Politics and Governance', 'Why do we have rules?', ['To fight', 'To keep everyone safe', 'To play', 'To keep things neat'], 1),
  _q('Politics and Governance', 'Who was the first Prime Minister of India?', ['Pandit Jawaharlal Nehru', 'Dr Rajendra Prasad', 'Indira Gandhi', 'Dr Sarvepalli Radhakrishnan'], 0),
  _q('Politics and Governance', 'Where is the Ashoka Chakra found?', ['On our book', 'On our coin', 'On our flag', 'On our cap'], 2),
  _q('Politics and Governance', 'What is the capital city of India?', ['Mumbai', 'Chennai', 'New Delhi', 'Kolkata'], 2),
  _q('Politics and Governance', 'Who helps the President or Prime Minister make decisions for the country?', ['Friends', 'Ministers', 'Teachers', 'Police'], 1),
];

final List<Question> _jobs = [
  _q('Jobs and Careers', 'I grow crops for you. Who am I?', ['Tailor', 'Farmer', 'Cobbler', 'Mason'], 1),
  _q('Jobs and Careers', 'Who stitches your clothes?', ['Doctor', 'Tailor', 'Electrician', 'Lawyer'], 1),
  _q('Jobs and Careers', 'Who among the following makes furniture?', ['Tailor', 'Postman', 'Carpenter', 'Doctor'], 2),
  _q('Jobs and Careers', 'Find the odd one out.', ['Doctor', 'Nurse', 'Chemist', 'Tailor'], 3),
  _q('Jobs and Careers', 'I take care of you and give you medicines when you are sick. Who am I?', ['Doctor', 'Policeman', 'Lawyer', 'Engineer'], 0),
  _q('Jobs and Careers', 'Where do you go to buy medicines?', ['Chemist shop', 'Bakery shop', 'Crockery shop', 'Post office'], 0),
  _q('Jobs and Careers', 'Who makes ornaments?', ['Mason', 'Goldsmith', 'Blacksmith', 'Cobbler'], 1),
  _q('Jobs and Careers', 'Who drives a car or bus?', ['Cook', 'Driver', 'Nurse', 'Carpenter'], 1),
  _q('Jobs and Careers', 'Who brings our letters?', ['Barber', 'Teacher', 'Postman', 'Pilot'], 2),
  _q('Jobs and Careers', 'Who cuts our hair?', ['Cook', 'Barber', 'Postman', 'Doctor'], 1),
];

final List<Question> _food = [
  _q('Food and Beverages', 'Tea and coffee are examples of:', ['Beverages', 'Vegetables', 'Pulses', 'Cereals'], 0),
  _q('Food and Beverages', 'The main food crop of South India is:', ['Wheat', 'Maize', 'Rice', 'Jowar'], 2),
  _q('Food and Beverages', 'What are French fries made from?', ['Meat', 'Wood', 'Tomatoes', 'Potatoes'], 3),
  _q('Food and Beverages', 'Mustard seeds and cardamom are examples of:', ['Spices', 'Cereals', 'Flowers', 'Pulses'], 0),
  _q('Food and Beverages', 'Which of the following is not a food item?', ['Ice cream', 'Pastry', 'Smart phone', 'Chocolate'], 2),
  _q('Food and Beverages', 'What is the food that we get from plants called?', ['Non-vegetarian food', 'Vegetarian food', 'Protective food', 'Body-building food'], 1),
  _q('Food and Beverages', 'Which fruit is called the king of fruits?', ['Mango', 'Guava', 'Banana', 'Pomegranate'], 0),
  _q('Food and Beverages', 'What do we eat in the morning?', ['Dinner', 'Lunch', 'Breakfast', 'Snacks'], 2),
  _q('Food and Beverages', 'Pav Bhaji is famous in which state?', ['West Bengal', 'Rajasthan', 'Gujarat', 'Maharashtra'], 3),
  _q('Food and Beverages', 'What do we drink?', ['Bread', 'Rice', 'Milk', 'Pizza'], 2),
];

final List<Question> _computer = [
  _q('Computer Applications', 'Which of these is an electronic machine?', ['Computer', 'Calculator', 'Television', 'Table'], 0),
  _q('Computer Applications', 'How many main parts are there in a computer system?', ['2', '5', '16', '100'], 1),
  _q('Computer Applications', 'Which part of the computer is called the brain of the computer?', ['Monitor', 'CPU', 'Keyboard', 'Printer'], 1),
  _q('Computer Applications', 'Which is not a part of the computer?', ['CPU', 'Monitor', 'Television', 'Keyboard'], 2),
  _q('Computer Applications', 'How are computers used in hospitals?', ["To keep patients' records", 'To sell tickets', 'To record TV shows', 'To check flight timings'], 0),
  _q('Computer Applications', 'Which of these devices is used to point at things on the monitor?', ['CPU', 'Keyboard', 'Mouse', 'Speakers'], 2),
  _q('Computer Applications', 'Which device do we use to type on a computer?', ['Piano', 'Pen', 'Printer', 'Keyboard'], 3),
  _q('Computer Applications', 'Which is the longest key on a keyboard?', ['Delete', 'Shift', 'Enter', 'Spacebar'], 3),
  _q('Computer Applications', 'Which of the following is the main memory of a computer?', ['RAM', 'ROM', 'CPU', 'CD'], 0),
  _q('Computer Applications', 'Which of the following refers to the physical parts of a computer?', ['Software', 'Compact disc', 'Mainframe', 'Hardware'], 3),
];

final List<Question> _currentAffairs = [
  _q('Current Affairs', 'Who is Sachin Tendulkar?', ['Boxer', 'Tennis player', 'Shooter', 'Cricketer'], 3),
  _q('Current Affairs', 'Chandrayaan-3 was launched from which place?', ['Sriharikota', 'Bengaluru', 'Pokhran', 'Visakhapatnam'], 0),
  _q('Current Affairs', 'How many days are there in a week?', ['7', '6', '8', '9'], 0),
  _q('Current Affairs', 'Name the National Tree of India.', ['Banyan tree', 'Peepal tree', 'Coconut tree', 'Ashoka tree'], 0),
  _q('Current Affairs', 'How many hours are there in a day?', ['10 hours', '20 hours', '23 hours', '24 hours'], 3),
  _q('Current Affairs', 'Who is the current Finance Minister of India?', ['Medha Patkar', 'Nirmala Sitharaman', 'Mamata Banerjee', 'Droupadi Murmu'], 1),
  _q('Current Affairs', 'Who is the current President of India?', ['Narendra Modi', 'Venkaiah Naidu', 'Ram Nath Kovind', 'Droupadi Murmu'], 3),
  _q('Current Affairs', 'Which team won the Indian Premier League (IPL) 2025 championship?', ['Chennai Super Kings', 'Mumbai Indians', 'Kolkata Knight Riders', 'Royal Challengers Bengaluru'], 3),
  _q('Current Affairs', "Which state will build the world's largest jungle safari park?", ['Tamil Nadu', 'Madhya Pradesh', 'Haryana', 'Nagaland'], 2),
  _q('Current Affairs', 'Who is the current Chief Minister of Karnataka?', ['D. K. Shivakumar', 'Basavaraj Bommai', 'Siddaramaiah', 'G. Parameshwara'], 0),
  _q('Current Affairs', 'What is the name of the new Parliament building of India?', ['Rashtrapati Bhavan', 'Chowdiah Memorial Hall', 'Town Hall', 'Sansad Bhavan'], 3),
  _q('Current Affairs', 'Name the biggest continent in the world.', ['Asia', 'Africa', 'Australia', 'Antarctica'], 0),
  _q('Current Affairs', 'How many continents are there in the world?', ['7', '8', '9', '10'], 0),
  _q('Current Affairs', 'How many districts are there in Karnataka?', ['24', '31', '28', '34'], 1),
  _q('Current Affairs', 'Which Indian state won the first prize for its presentation in the Republic Day Parade 2026?', ['Madhya Pradesh', 'Uttar Pradesh', 'Maharashtra', 'Rajasthan'], 2),
  _q('Current Affairs', 'What do we call the place where books are kept?', ['Library', 'Playground', 'Kitchen room', 'Mall'], 0),
  _q('Current Affairs', 'Which superhero wears a red and blue suit and swings on webs?', ['Batman', 'Spiderman', 'Superman', 'Ironman'], 1),
  _q('Current Affairs', 'What is the name of the operation conducted by India in response to a terrorist attack in Kashmir in 2025?', ['Operation Vijay', 'Operation Sindoor', 'Operation Shakti', 'Operation Trident'], 1),
  _q('Current Affairs', 'What is the currency of India?', ['Dollar', 'Rupee', 'Pound', 'Euro'], 1),
  _q('Current Affairs', 'Who is the current Prime Minister of India?', ['Arvind Kejriwal', 'Narendra Modi', 'Rahul Gandhi', 'Yogi Adityanath'], 1),
];

final List<Question> _math = [
  _q('Mathematics', 'Which shape is round?', ['Square', 'Triangle', 'Rectangle', 'Circle'], 3),
  _q('Mathematics', '5 + 2 = ?', ['3', '6', '7', '4'], 2),
  _q('Mathematics', 'Which is heavier?', ['Feather', 'Stone', 'Leaf', 'Paper'], 1),
  _q('Mathematics', 'How many 50 paise coins are there in Rs 2?', ['2', '4', '6', '8'], 1),
  _q('Mathematics', 'When both hands of a clock overlap, what time is it?', ['12:30', '11:50', '12:00', '6:00'], 2),
  _q('Mathematics', 'How many years make a century?', ['50', '20', '1000', '100'], 3),
  _q('Mathematics', 'How many months do we have in a year?', ['10 months', '24 months', '12 months', '14 months'], 2),
  _q('Mathematics', 'If today is Tuesday, what day was yesterday?', ['Monday', 'Wednesday', 'Thursday', 'Sunday'], 0),
  _q('Mathematics', 'Which number name is correct?', ['5 — Five', '7 — Ten', '3 — Nine', '2 — Eight'], 0),
  _q('Mathematics', 'How many fingers are on one hand?', ['4', '3', '6', '5'], 3),
  _q('Mathematics', 'In a leap year, how many days are there in February?', ['28', '29', '30', '31'], 1),
  _q('Mathematics', 'Which is the longest object?', ['Pencil', 'Eraser', 'Ruler', 'Sharpener'], 2),
  _q('Mathematics', 'How many corners does a square have?', ['3', '2', '4', '5'], 2),
  _q('Mathematics', 'Which of the following is an even number?', ['3', '5', '6', '99'], 2),
  _q('Mathematics', 'Ravi has 3 pencils. His friend gave him 4 more. How many pencils does he have now?', ['6', '7', '8', '9'], 1),
  _q('Mathematics', 'Which shape has no corners?', ['Triangle', 'Square', 'Rectangle', 'Circle'], 3),
  _q('Mathematics', 'Which number is between 47 and 49?', ['46', '48', '50', '47'], 1),
  _q('Mathematics', 'Meena had 6 balloons. She bought 5 more. Then 2 balloons flew away. How many balloons does she have now?', ['11', '9', '10', '8'], 1),
  _q('Mathematics', 'Which month comes after May?', ['April', 'June', 'July', 'March'], 1),
  _q('Mathematics', 'Which number is the smallest?', ['2', '5', '9', '7'], 0),
];

final List<Question> _aptitude = [
  _q('Aptitude, Analytical, Critical Thinking and Logical Reasoning', 'Which number comes next in this series: 1, 3, 5, 7, ....?', ['11', '9', '8', '10'], 1),
  _q('Aptitude, Analytical, Critical Thinking and Logical Reasoning', 'Which is taller?', ['Pencil', 'Tree', 'Book', 'Eraser'], 1),
  _q('Aptitude, Analytical, Critical Thinking and Logical Reasoning', 'How many squares do you see in this picture?', ['2', '1', '4', '5'], 3, figure: Art.squareGrid),
  _q('Aptitude, Analytical, Critical Thinking and Logical Reasoning', 'Which of the following looks like a cone?', ['Square', 'Triangle', 'Circle', 'Cylinder'], 1, optionArts: [Art.square, Art.triangle, Art.circle, Art.cylinder]),
  _q('Aptitude, Analytical, Critical Thinking and Logical Reasoning', 'How many flowers will be there in Pattern 4?', ['10', '14', '12', '16'], 0, figure: Art.flowers),
  _q('Aptitude, Analytical, Critical Thinking and Logical Reasoning', 'What sound does a dog make?', ['Meow', 'Woof', 'Moo', 'Chirp'], 1),
  _q('Aptitude, Analytical, Critical Thinking and Logical Reasoning', 'Which figure shows an equal collection?', ['3 dots and 4 dots', '4 dots and 4 dots', '5 dots and 6 dots', '2 dots and 3 dots'], 1, optionArts: [Art.dotsUnevenA, Art.dotsEqual, Art.dotsUnevenC, Art.dotsUnevenD]),
  _q('Aptitude, Analytical, Critical Thinking and Logical Reasoning', 'Which number comes next in the pattern 6, 12, 18, 24, 30, ?', ['32', '36', '34', '40'], 1),
  _q('Aptitude, Analytical, Critical Thinking and Logical Reasoning', 'What comes after 25?', ['23', '24', '26', '27'], 2),
  _q('Aptitude, Analytical, Critical Thinking and Logical Reasoning', "If it's raining, what should you take with you?", ['Sun glasses', 'Umbrella', 'Hat', 'Ice cream'], 1),
  _q('Aptitude, Analytical, Critical Thinking and Logical Reasoning', 'There are 7 ones and 8 tens in ________.', ['78', '32', '29', '87'], 3),
  _q('Aptitude, Analytical, Critical Thinking and Logical Reasoning', 'How many circles are there in the given figure?', ['7', '8', '100', '9'], 3, figure: Art.circleCluster),
  _q('Aptitude, Analytical, Critical Thinking and Logical Reasoning', 'Arrange the circles from the smallest to the largest.', ['1, 2, 3, 4', '4, 2, 3, 1', '2, 1, 4, 3', '3, 2, 1, 4'], 3, figure: Art.sizedCircles),
  _q('Aptitude, Analytical, Critical Thinking and Logical Reasoning', 'If a glass falls, what will happen?', ['It will fly', 'It will bounce', 'It will break', 'It will grow'], 2),
  _q('Aptitude, Analytical, Critical Thinking and Logical Reasoning', 'Which one is different?', ['Pig', 'Rat', 'Mouse', 'Car'], 3, optionArts: [Art.pig, Art.rat, Art.mouse, Art.car]),
  _q('Aptitude, Analytical, Critical Thinking and Logical Reasoning', 'Which is the shortest?', ['Giraffe', 'Elephant', 'Rabbit', 'Horse'], 2),
  _q('Aptitude, Analytical, Critical Thinking and Logical Reasoning', 'If the sun is shining, what time is it likely to be?', ['Day', 'Night', 'Winter', 'Cloudy'], 0),
  _q('Aptitude, Analytical, Critical Thinking and Logical Reasoning', 'Which number should be added to 3 to make 9?', ['5', '6', '7', '8'], 1),
  _q('Aptitude, Analytical, Critical Thinking and Logical Reasoning', 'What comes next?', ['Triangle', 'Circle', 'Rectangle', 'Pentagon'], 0, figure: Art.shapeSequence, optionArts: [Art.triangle, Art.circle, Art.rectangle, Art.pentagon]),
  _q('Aptitude, Analytical, Critical Thinking and Logical Reasoning', 'What do you do before crossing a road?', ['Run fast', 'Close eyes', 'Look both sides', 'Shout'], 2),
];
