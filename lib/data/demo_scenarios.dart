import '../models/game_scenario.dart';
import '../models/game_choice.dart';

const List<GameScenario> demoScenarios = [
  GameScenario(
    id: 'morning_planning',
    title: 'Morning Planning',
    timeLabel: '8:00 AM',
    sceneTone: 'morning',
    description:
        'Alex sits at the kitchen table and opens a notebook to find a long list of assignments, a group project due this week, and two after-school commitments. The list stretches across two pages.',
    narration:
        '"Everything is due. All of it. At once. Where do I even start?"',
    choices: [
      GameChoice(
        id: 'try_everything',
        label: 'Try to complete everything without planning',
        description:
            'Push through and attempt every task on the list without stopping to organize.',
        energyDelta: -20,
        stressDelta: 25,
        motivationDelta: -10,
        timeMinutesDelta: 90,
        educationalFeedback:
            'Attempting everything at once increased demands without a clear structure. This left Alex feeling more overwhelmed and drained more energy than a planned approach would. High demand without prioritization can accelerate burnout over the course of a day.',
      ),
      GameChoice(
        id: 'break_into_steps',
        label: 'Break the work into smaller steps and choose three priorities',
        description:
            'Write down everything, then circle the three most important items for today.',
        energyDelta: -5,
        focusDelta: 15,
        stressDelta: -15,
        motivationDelta: 10,
        timeMinutesDelta: 40,
        taskCompleted: 'Morning planning completed',
        educationalFeedback:
            'Breaking tasks into smaller steps is a strategy that supports executive function. By identifying three priorities, Alex reduced the feeling of overwhelm and created a clearer path forward. This choice preserved more energy and improved focus for the rest of the day.',
      ),
      GameChoice(
        id: 'avoid_list',
        label: 'Avoid looking at the list',
        description:
            'Close the notebook and scroll through a phone instead to avoid the feeling of overwhelm.',
        energyDelta: 5,
        stressDelta: -5,
        motivationDelta: -15,
        timeMinutesDelta: 20,
        educationalFeedback:
            'Stepping away reduced immediate stress briefly. However, the tasks remain unresolved. Avoiding demands can increase anxiety over time as deadlines approach. This choice preserved some energy but left the day\'s demands unaddressed. Short breaks differ from avoidance — the goal matters.',
      ),
    ],
  ),
  GameScenario(
    id: 'class_project',
    title: 'Class Project',
    timeLabel: '10:30 AM',
    sceneTone: 'class',
    description:
        'In class, the teacher assigns group roles for a project. Alex is given a role requiring prolonged organization and repetitive documentation. Another student gets visual design and idea generation — a much better fit for Alex\'s strengths.',
    narration:
        '"I can already see exactly how the design should look. But they want me to fill out tables of data instead."',
    choices: [
      GameChoice(
        id: 'accept_silently',
        label: 'Accept the assigned role without saying anything',
        description:
            'Stay quiet and begin the documentation task even though it does not match Alex\'s strengths.',
        energyDelta: -20,
        focusDelta: -10,
        stressDelta: 20,
        motivationDelta: -15,
        selfAdvocacyDelta: -10,
        timeMinutesDelta: 60,
        educationalFeedback:
            'Accepting a role that clashes with one\'s strengths without communication increased stress and reduced motivation. Prolonged engagement in mismatched tasks consumes more energy. This reflects a common experience for neurodivergent students who may find self-advocacy difficult or risky. The impact is not a personal failing.',
      ),
      GameChoice(
        id: 'advocate_with_teacher',
        label:
            'Ask the teacher to contribute through visual design while completing some documentation',
        description:
            'Raise a hand and ask whether it is possible to help with design while also completing a smaller portion of the documentation.',
        energyDelta: -5,
        focusDelta: 15,
        stressDelta: -10,
        motivationDelta: 20,
        selfAdvocacyDelta: 25,
        timeMinutesDelta: 70,
        taskCompleted: 'Self-advocacy practiced in class',
        educationalFeedback:
            'Asking for a role that matched Alex\'s strengths is an example of self-advocacy. This increased engagement and motivation. Speaking up can feel effortful, and the outcome may not always go as hoped. Practicing self-advocacy is a skill that often becomes more accessible over time with support.',
      ),
      GameChoice(
        id: 'refuse_participation',
        label: 'Refuse to participate completely',
        description:
            'Decline the assignment entirely and sit out of the group work.',
        energyDelta: 10,
        stressDelta: 15,
        motivationDelta: -20,
        lifeSatisfactionDelta: -20,
        timeMinutesDelta: 60,
        educationalFeedback:
            'Opting out preserved immediate energy. However, this left the demand unresolved and introduced new stress about consequences. Life satisfaction decreased because an opportunity for connection and accomplishment was missed. Sometimes stepping back is necessary and sometimes the reasons for refusing deserve closer attention from supportive adults.',
      ),
    ],
  ),
  GameScenario(
    id: 'end_of_day',
    title: 'End of Day',
    timeLabel: '4:00 PM',
    sceneTone: 'evening',
    description:
        'School is over. Alex is home with limited time and energy. There is still unfinished work on the desk, and a favorite creative digital project has been waiting all day. The body feels heavy.',
    narration:
        '"I want to work on my project. But I\'m not sure I have anything left to give it."',
    choices: [
      GameChoice(
        id: 'work_until_done',
        label: 'Continue working until everything is finished',
        description:
            'Push through and try to complete all remaining assignments before resting.',
        energyDelta: -30,
        stressDelta: 20,
        motivationDelta: -25,
        lifeSatisfactionDelta: -10,
        timeMinutesDelta: 120,
        taskCompleted: 'Additional assignments attempted',
        educationalFeedback:
            'Continuing to work when energy is already low can deplete reserves needed for recovery. Completing tasks through exhaustion may make future demands harder to manage. Recognizing when to stop is itself a skill — not a failure. Rest is part of sustainable functioning, not a reward earned by finishing everything.',
      ),
      GameChoice(
        id: 'break_then_priority',
        label: 'Take a short movement break, finish one priority, then stop',
        description:
            'Step away for ten minutes, complete the most important remaining task, and then let the evening be rest.',
        energyDelta: 5,
        focusDelta: 10,
        stressDelta: -10,
        motivationDelta: 5,
        lifeSatisfactionDelta: 10,
        timeMinutesDelta: 80,
        taskCompleted: 'Priority task completed with recovery break',
        educationalFeedback:
            'Short movement breaks can support attention regulation and reduce accumulated stress. Completing one priority task before stopping kept progress moving without depleting remaining energy. This balance supported a better chance of retaining access to a valued activity later in the evening.',
      ),
      GameChoice(
        id: 'stop_and_rest',
        label: 'Stop all work and listen to music',
        description:
            'Close the books, put on a favorite playlist, and let the evening be a full rest.',
        energyDelta: 20,
        stressDelta: -25,
        motivationDelta: 10,
        lifeSatisfactionDelta: 5,
        timeMinutesDelta: 40,
        educationalFeedback:
            'Choosing rest when the body and mind are depleted is a valid and often necessary strategy. Not all demands can or should be completed in a single day. Recovery time is not laziness. Different people need different amounts of rest, and this need varies by day and circumstance. Honoring that is a form of self-knowledge.',
      ),
    ],
  ),
];
