import '../models/game_scenario.dart';
import '../models/game_choice.dart';

const List<GameScenario> alexScenarios = [
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
        tag: 'chaotic_morning',
        educationalFeedback:
            'Attempting everything at once increased demands without a clear structure. This left Alex feeling more overwhelmed and drained more energy than a planned approach would have. High demand without prioritization can accelerate burnout over the course of a day.',
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
        tag: 'planned_morning',
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
    id: 'sensory_hallway',
    title: 'Morning Hallways',
    timeLabel: '9:30 AM',
    sceneTone: 'class',
    carryoverNotes: {
      'chaotic_morning':
          'After a rushed and chaotic start to the morning, the hallway crowd hit harder than usual. Alex was already running low before the noise arrived.',
    },
    description:
        'The hallways fill up between periods. Lockers slam in short bursts. Someone nearby is wearing strong perfume. Two students are arguing loudly near the stairwell. Alex needs to get to class across the building.',
    narration:
        '"Every sound feels like it\'s landing directly on me. I just need to get to class."',
    choices: [
      GameChoice(
        id: 'push_through_crowd',
        label: 'Walk quickly through the crowded hallway without stopping',
        description:
            'Keep moving, head down, and push through the stimulation as fast as possible.',
        energyDelta: -15,
        stressDelta: 20,
        focusDelta: -10,
        timeMinutesDelta: 10,
        tag: 'pushed_sensory',
        educationalFeedback:
            'Moving through a high-stimulation environment without pause can overload the sensory system. Arriving at class faster came at the cost of accumulated tension. This stress doesn\'t disappear when class starts — it carries forward, making focus harder in the next period.',
      ),
      GameChoice(
        id: 'wait_at_wall',
        label: 'Step aside and wait near a wall until the rush passes',
        description:
            'Move to the edge of the hallway and pause until the crowd thins out, then continue at a comfortable pace.',
        energyDelta: -5,
        stressDelta: -10,
        focusDelta: 5,
        timeMinutesDelta: 15,
        tag: 'sensory_break_taken',
        educationalFeedback:
            'Allowing a crowded hallway to clear before moving through it reduced sensory load significantly. Arriving at class a few minutes later but calmer is often a worthwhile tradeoff. Choosing when to engage with high-stimulation situations is a form of self-regulation, not avoidance.',
      ),
      GameChoice(
        id: 'mindful_walk',
        label: 'Move slowly and focus on breathing while walking through',
        description:
            'Use a steady breathing rhythm as a grounding anchor while moving through the noise and activity.',
        energyDelta: -8,
        stressDelta: 5,
        focusDelta: 5,
        timeMinutesDelta: 12,
        tag: 'mindful_transition',
        educationalFeedback:
            'Focusing on breathing while moving through a stimulating environment is a grounding technique. It doesn\'t eliminate the sensory input but can moderate the stress response. This approach keeps some calm available even in a demanding environment.',
      ),
    ],
  ),
  GameScenario(
    id: 'class_project',
    title: 'Class Project',
    timeLabel: '9:45 AM',
    sceneTone: 'class',
    carryoverNotes: {
      'pushed_sensory':
          'Alex arrived still buzzing from the hallway noise. Classmates talking nearby felt louder than usual, making it harder to catch what the teacher was saying.',
    },
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
        tag: 'stayed_silent',
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
        tag: 'advocated_role',
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
    id: 'lunch_recovery',
    title: 'Lunch Break',
    timeLabel: '11:00 AM',
    sceneTone: 'evening',
    carryoverNotes: {
      'pushed_sensory':
          'The sensory pressure from this morning\'s crowded hallway hasn\'t fully lifted. The need for quiet feels urgent, not just preferable.',
      'stayed_silent':
          'Sitting with a mismatched role for a full period left Alex\'s motivation lower than usual. Something restorative — not just food — feels necessary.',
    },
    description:
        'Alex has a free 30-minute lunch period. The cafeteria is loud and crowded. A quieter spot outside near the courtyard is open. Alex has eaten only a granola bar since this morning.',
    narration:
        '"I need something. I\'m not sure if it\'s food, quiet, movement, or all three."',
    choices: [
      GameChoice(
        id: 'cafeteria_social',
        label: 'Eat in the cafeteria with classmates',
        description:
            'Sit with the usual group. The noise is significant, but so is the social connection.',
        energyDelta: -10,
        stressDelta: 10,
        motivationDelta: 5,
        lifeSatisfactionDelta: 5,
        focusDelta: -5,
        timeMinutesDelta: 30,
        educationalFeedback:
            'Social connection can be restorative for some people and draining for others — and often both at once. The cafeteria provided lunch and a sense of belonging, but the high sensory environment countered some of the benefit. The net effect depends on where Alex\'s energy was before and what the rest of the afternoon holds.',
      ),
      GameChoice(
        id: 'quiet_spot_outside',
        label: 'Find a quiet spot outside with headphones and eat alone',
        description:
            'Take lunch outside to a less crowded area. Headphones, food, and 30 minutes of low stimulation.',
        energyDelta: 15,
        stressDelta: -20,
        focusDelta: 10,
        motivationDelta: 5,
        timeMinutesDelta: 30,
        tag: 'quiet_lunch',
        educationalFeedback:
            'Choosing a low-stimulation environment during lunch allowed Alex\'s nervous system to partially recover. Eating and resting quietly restored energy more effectively than staying in high demand. Not all recovery looks like sleep — this is how many people with sensory sensitivities recharge.',
      ),
      GameChoice(
        id: 'stim_walk',
        label: 'Take a stim walk around the building, then eat',
        description:
            'Walk the perimeter of the school at a comfortable pace before eating. Rhythmic movement can help discharge accumulated sensory tension.',
        energyDelta: 10,
        stressDelta: -15,
        focusDelta: 5,
        motivationDelta: 10,
        timeMinutesDelta: 30,
        tag: 'stim_recovery',
        educationalFeedback:
            'Stimming — repetitive movement or self-soothing behaviors — is a natural self-regulation tool for many neurodivergent people. A rhythmic walk serves a similar function. Movement helps discharge accumulated stress and can improve focus for the next period. This is a valid strategy, not a habit to suppress.',
      ),
      GameChoice(
        id: 'skip_lunch_work',
        label: 'Skip eating and use the time to catch up on homework',
        description:
            'Use the lunch period for academic work instead of recovery.',
        energyDelta: -20,
        stressDelta: 15,
        focusDelta: -10,
        motivationDelta: -10,
        timeMinutesDelta: 30,
        maxBurnoutAllowed: 65,
        unavailableReason:
            'Alex\'s system is too depleted to focus on work without food or rest. When burnout is this high, skipping recovery time tends to compound the deficit rather than reduce it.',
        educationalFeedback:
            'Using recovery time for work output can feel productive but often produces diminishing returns. When energy and food are both low, cognitive performance degrades significantly. The tasks may take longer than they would after a proper break — and the cost of skipping rest carries forward into the afternoon.',
      ),
    ],
  ),
  GameScenario(
    id: 'end_of_day',
    title: 'Final School Hour',
    timeLabel: '2:00 PM',
    endTimeLabel: '3:00 PM',
    sceneTone: 'evening',
    carryoverNotes: {
      'quiet_lunch':
          'The midday break paid off. Alex arrived home with a little more left in reserve than the morning suggested.',
      'stim_recovery':
          'The stim walk at lunch helped regulate the accumulated stress. Alex can feel the difference — the evening feels slightly more possible.',
    },
    description:
        'The final hour of the school day is beginning. Alex has limited time and energy, unfinished work to plan for, and a favorite creative digital project waiting at home. The body feels heavy.',
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
        timeMinutesDelta: 60,
        taskCompleted: 'Additional assignments attempted',
        minEnergyRequired: 30,
        maxBurnoutAllowed: 70,
        unavailableReason:
            'Alex doesn\'t have enough capacity to sustain this level of effort right now. When burnout is high and energy is low, pushing through extended work tends to compound the deficit rather than resolve it. This is not a choice — it\'s a capacity limit.',
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
        timeMinutesDelta: 60,
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
        timeMinutesDelta: 60,
        educationalFeedback:
            'Choosing rest when the body and mind are depleted is a valid and often necessary strategy. Not all demands can or should be completed in a single day. Recovery time is not laziness. Different people need different amounts of rest, and this need varies by day and circumstance. Honoring that is a form of self-knowledge.',
      ),
    ],
  ),
];
