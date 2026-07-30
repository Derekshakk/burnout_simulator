import '../models/game_scenario.dart';
import '../models/game_choice.dart';

const List<GameScenario> alexScenarios = [
  // S1 — Morning Planning (unchanged)
  GameScenario(
    id: 'morning_planning',
    title: 'Morning Planning',
    timeLabel: '8:00 AM',
    sceneTone: 'morning',
    sceneImagePath: 'assets/stories/alex_productive.jpg',
    sceneSemanticLabel: 'Illustration of Alex planning their day at a desk',
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

  // S2 — Morning Hallways (unchanged)
  GameScenario(
    id: 'sensory_hallway',
    title: 'Morning Hallways',
    timeLabel: '9:30 AM',
    sceneTone: 'hallway',
    sceneImagePath: 'assets/stories/hallway_background.jpg',
    sceneSemanticLabel: 'Illustration of a busy school hallway between classes',
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

  // S3 — Group Project Start (replaces class_project; integrates Restlessness + Looking Productive notes)
  GameScenario(
    id: 'class_restlessness',
    title: 'Group Project Start',
    timeLabel: '10:00 AM',
    sceneTone: 'class',
    sceneImagePath: 'assets/stories/jordan_classroom.jpg',
    sceneSemanticLabel: 'Illustration of a classroom during a group project',
    carryoverNotes: {
      'chaotic_morning':
          'Alex arrived at this period already stretched thin. The group project waited while restlessness grew louder.',
      'pushed_sensory':
          'The sensory pressure from the hallway carried into the classroom. Sitting still felt harder than usual.',
    },
    description:
        'Thirty minutes into the period, the teacher has assigned a group project. Other students appear to have started. Alex hasn\'t — the task feels large, the first step unclear, and staying still is getting harder.',
    narration:
        '"Everyone looks like they know exactly what to do. I\'ve been staring at the same blank page for twenty minutes."',
    choices: [
      GameChoice(
        id: 'sit_still_pretend',
        label: 'Force sitting still and appear to be working',
        description:
            'Hold the restlessness in and look busy, hoping the task somehow becomes clearer.',
        energyDelta: -18,
        stressDelta: 22,
        focusDelta: -15,
        motivationDelta: -10,
        selfAdvocacyDelta: -5,
        timeMinutesDelta: 55,
        tag: 'masked_restless',
        educationalFeedback:
            'Holding restlessness in while also avoiding a task requires two layers of effort simultaneously. Energy goes toward appearing still rather than engaging with the work. Over time, this pattern compounds: the task does not start, and the cost of masking keeps adding up.',
      ),
      GameChoice(
        id: 'fidget_and_break_task',
        label: 'Fidget discreetly and break the assignment into smaller steps',
        description:
            'Allow small physical movement — tapping, shifting — while writing out what the assignment actually requires, step by step.',
        energyDelta: -5,
        focusDelta: 15,
        stressDelta: -10,
        motivationDelta: 10,
        timeMinutesDelta: 55,
        taskCompleted: 'Group project started with task breakdown',
        tag: 'task_started_fidget',
        educationalFeedback:
            'Allowing natural, discreet movement can reduce restlessness enough to free attention for the task. Breaking the assignment into smaller steps addresses the initiation barrier directly — it answers the question "where do I start?" rather than expecting motivation to arrive before a plan exists.',
      ),
      GameChoice(
        id: 'ask_classmate_help',
        label: 'Ask a classmate how they got started',
        description:
            'Lean over and ask a nearby student what they are working on first.',
        energyDelta: -8,
        stressDelta: -5,
        focusDelta: 10,
        motivationDelta: 15,
        selfAdvocacyDelta: 15,
        timeMinutesDelta: 55,
        taskCompleted: 'Asked a peer for help getting started',
        tag: 'peer_helped_start',
        educationalFeedback:
            'Asking for help with task initiation is not the same as asking for answers. Many people with ADHD find starting the hardest part — an external prompt or a brief exchange with a peer can function as the activation cue the brain needs. This is a practical strategy, not a sign of inability.',
      ),
      GameChoice(
        id: 'ask_teacher_movement',
        label:
            'Ask the teacher quietly whether standing or taking a brief movement break is possible',
        description:
            'Wait for a moment when the teacher is nearby and ask whether working while standing or stepping out briefly is an option during the period.',
        energyDelta: -8,
        stressDelta: -5,
        focusDelta: 12,
        selfAdvocacyDelta: 18,
        motivationDelta: 5,
        timeMinutesDelta: 55,
        taskCompleted: 'Requested a movement accommodation from teacher',
        tag: 'asked_movement_accommodation',
        educationalFeedback:
            'Asking for permission to stand or take a brief movement break is a functional accommodation request — it does not require naming ADHD or providing documentation. "I focus better with some movement" is an accurate and complete reason. Teachers who respond supportively signal that the classroom has room for different working styles. The cost of asking is real; the benefit, when it works, can change the whole period.',
      ),
    ],
  ),

  // S4 — Lunch Break: moved to shared_scenarios.dart as buildLunchBreakScenario(alex).
  //       Wired in character_registry.dart at slot 4.

  // S5 — Final School Hour (revised: integrates Time Awareness note; adds reprioritize + timer choices)
  GameScenario(
    id: 'end_of_day',
    title: 'Final School Hour',
    timeLabel: '2:00 PM',
    endTimeLabel: '3:00 PM',
    sceneTone: 'evening',
    sceneImagePath: 'assets/stories/time_Awareness.jpg',
    sceneSemanticLabel:
        'Illustration representing time awareness at the end of the school day',
    carryoverNotes: {
      'quiet_lunch':
          'The midday break paid off. Alex arrived at the final hour with a little more left in reserve than the morning suggested.',
      'stim_recovery':
          'The stim walk at lunch helped regulate the accumulated stress. Alex can feel the difference — the final hour feels slightly more possible.',
    },
    description:
        'The final hour of the school day is winding down. Looking back at the task list from this morning, one subject somehow absorbed the entire homework period. Several items are untouched. Energy is low, and the evening still holds more than it should.',
    narration:
        '"How is it already two o\'clock? I barely got through one thing. And there\'s still a whole list."',
    choices: [
      GameChoice(
        id: 'panic_rush_remaining',
        label: 'Panic and try to rush through all remaining work',
        description:
            'Attempt everything at once, moving fast to try to recover the lost time.',
        energyDelta: -30,
        stressDelta: 25,
        motivationDelta: -20,
        lifeSatisfactionDelta: -10,
        timeMinutesDelta: 60,
        taskCompleted: 'Remaining assignments rushed through',
        minEnergyRequired: 30,
        maxBurnoutAllowed: 70,
        unavailableReason:
            'Alex doesn\'t have enough capacity to sustain this level of effort right now. Pushing through without capacity often compounds the deficit rather than resolving it. This is not a choice — it\'s a limit.',
        educationalFeedback:
            'Rushing through multiple tasks in response to time pressure can produce low-quality output and significant additional stress. Time blindness — losing track of how long a task takes — is a common experience with ADHD, not a character flaw. Reacting with panic tends to add to the problem rather than resolve it.',
      ),
      GameChoice(
        id: 'reprioritize_calmly',
        label:
            'Stop, identify what actually matters today, and finish one task',
        description:
            'Take a few minutes to look at what is genuinely due and in what order, then complete only the highest-priority item.',
        energyDelta: 5,
        focusDelta: 10,
        stressDelta: -10,
        motivationDelta: 5,
        lifeSatisfactionDelta: 10,
        timeMinutesDelta: 60,
        taskCompleted: 'Reprioritized and completed one key task',
        educationalFeedback:
            'Pausing to reprioritize after realizing time has passed is a regulation strategy, not giving up. Identifying what actually needs to happen today — versus what can wait — reduces the gap between demands and available capacity. One completed priority is more sustainable than several rushed, incomplete ones.',
      ),
      GameChoice(
        id: 'set_timers_and_work',
        label: 'Set a timer for each remaining task and work through them',
        description:
            'Divide the remaining time into timed chunks, assign one task to each, and use the timer as an external cue to stay on track.',
        focusDelta: 15,
        stressDelta: -5,
        motivationDelta: 10,
        timeMinutesDelta: 60,
        taskCompleted: 'Used timers to structure remaining work',
        tag: 'timer_strategy',
        educationalFeedback:
            'External timers provide structure that an internal sense of time may not reliably offer. For many people with ADHD, working in defined time chunks — sometimes called time-boxing — makes tasks feel more manageable and provides a clear signal for when to stop. This is an accommodation strategy, not a workaround.',
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
