Readme for MultipleChoiceImageQuiz
by Nathan Jensen

This was created to be published to iPad and iPhone devices.
It is xml feed.  The xml file is located in the assets folder.

The basic xml structure is this:
	<lesson>
		<question>
			<questionText>?</questionText>
			<image>zero.png</image>
			<audio>zero-chinese-ling.mp3</audio>
			<correctAnswer>zero</correctAnswer>
			<distractor>ten</distractor>
			<distractor>two</distractor>
			<distractor>seven</distractor>
		</question>		
		<question>
			<questionText>?</questionText>
			<image>zero.png</image>
			<audio>zero-chinese-ling.mp3</audio>
			<correctAnswer>zero</correctAnswer>
			<distractor>ten</distractor>
			<distractor>two</distractor>
			<distractor>seven</distractor>
		</question>		
	</lesson>
	
	
The <questionText> tag displays very large text for each question.  The <image> tag
is used instead of the <questionText> tag and loads a image file from the assets folder,
scales it, and places it in the questioning area.  Using both of these tags together in 
the smame <question> will produce unexpected results.

The <audio> tag looks for the given audio file in the assest/audio folder.