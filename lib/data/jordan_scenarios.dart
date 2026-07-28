import '../models/game_scenario.dart';
import '../models/game_choice.dart';

const List<GameScenario> jordanScenarios = [
  GameScenario(
    id: 'routine_disruption',
    title: 'Room Change',
    timeLabel: '8:30 AM',
    sceneTone: 'morning',
    description:
        'Jordan arrives at the usual classroom to find a note taped to the door: the room has been moved to a different wing, effective today. No email. No prior announcement. The new room number is unfamiliar. Other students brush past, seemingly already aware.',
    narration:
        '"This was not what I prepared for. I rehearsed this morning — this hallway, this door. None of that applies now."',
    choices: [
      GameChoice(
        id: 'freeze_and_panic',
        label:
            'Stand frozen in the hallway, overwhelmed by the unexpected change',
        description:
            'The disruption is too abrupt. Jordan\'s mental plan doesn\'t have a fallback for this. Arrives to the new room late.',
        energyDelta: -20,
        stressDelta: 30,
        focusDelta: -20,
        selfAdvocacyDelta: -5,
        timeMinutesDelta: 20,
        tag: 'routine_panic',
        educationalFeedback:
            'Unexpected changes to routine can trigger a freeze response in autistic people, particularly when the disruption occurs at a transition point they had mentally prepared for. This is not a failure of flexibility — it reflects a genuine mismatch between an environment designed without predictability and a nervous system that relies on it. The freeze response is neurological, not a character flaw.',
      ),
      GameChoice(
        id: 'check_map_breathe',
        label:
            'Take three slow breaths, find the posted map, locate the new room calmly',
        description:
            'Pause, use a brief grounding technique, consult the map on the nearby wall, and navigate to the correct room.',
        energyDelta: -10,
        stressDelta: 5,
        focusDelta: 5,
        timeMinutesDelta: 15,
        tag: 'routine_adapted',
        educationalFeedback:
            'Using a brief grounding technique before acting — rather than reacting immediately — gave Jordan\'s nervous system time to shift gears. Consulting a posted map is a concrete strategy that works even when mental preparation has been disrupted. Adapting to unexpected changes takes more effort for autistic people, and that effort is real, even when the outcome looks smooth from the outside.',
      ),
      GameChoice(
        id: 'ask_passing_student',
        label: 'Ask a nearby student if they know where the new room is',
        description:
            'Initiate brief, practical social contact to get the information needed quickly.',
        energyDelta: -8,
        stressDelta: -5,
        selfAdvocacyDelta: 10,
        timeMinutesDelta: 10,
        taskCompleted: 'Navigated unexpected schedule change',
        tag: 'asked_for_help',
        educationalFeedback:
            'Asking for practical help from a peer is a form of self-advocacy that can be easier or harder depending on the social demands involved. When it works, it efficiently resolves an immediate problem. Practicing this kind of low-stakes request can build confidence for higher-stakes situations later. The effort to initiate social contact is not trivial and is worth recognizing.',
      ),
    ],
  ),
  GameScenario(
    id: 'group_work_ambiguous',
    title: 'Unstructured Group Work',
    timeLabel: '8:50 AM',
    sceneTone: 'class',
    carryoverNotes: {
      'routine_panic':
          'After the morning disruption, Jordan arrived in class already depleted. The ambiguity of the group project stacked on a nervous system that hadn\'t finished resetting.',
    },
    description:
        'The teacher announces a group project, assigns groups at random, and distributes a vague instruction sheet. Phrases like "be creative" and "demonstrate your understanding" appear without rubric or clear success criteria. Jordan\'s group immediately begins talking over each other without a shared direction.',
    narration:
        '"What does \'demonstrate understanding\' mean for a grade? I can\'t start without knowing what I\'m aiming for. Why is everyone just guessing?"',
    choices: [
      GameChoice(
        id: 'stay_quiet_follow',
        label:
            'Stay quiet and try to follow along, guessing at what\'s expected',
        description:
            'Don\'t draw attention. Try to piece together expectations from the group\'s behavior and hope it\'s enough.',
        energyDelta: -20,
        stressDelta: 25,
        focusDelta: -15,
        selfAdvocacyDelta: -10,
        timeMinutesDelta: 60,
        tag: 'masked_confusing',
        educationalFeedback:
            'Attempting to mask confusion and infer unstated expectations is exhausting and often unsuccessful. The cognitive load of simultaneously decoding social cues and guessing at academic criteria is significant. This experience is common for autistic students in unstructured group settings. The result — high stress, low focus, low output — is a consequence of the environment, not a personal limitation.',
      ),
      GameChoice(
        id: 'ask_teacher_criteria',
        label:
            'Ask the teacher to clarify the grading criteria before the group starts',
        description:
            'Raise a hand and ask what specific outcomes the teacher is looking for and how the project will be evaluated.',
        energyDelta: -10,
        stressDelta: -10,
        selfAdvocacyDelta: 20,
        focusDelta: 15,
        timeMinutesDelta: 70,
        taskCompleted: 'Clarified assignment expectations',
        tag: 'sought_clarity',
        educationalFeedback:
            'Asking for clear criteria is a form of academic self-advocacy. For many autistic students, ambiguous instructions are genuinely harder to work with — not a matter of preference. Requesting specificity benefits everyone in the class but may require more social effort for some students. A nonjudgmental response from the teacher models that asking is safe.',
      ),
      GameChoice(
        id: 'suggest_task_list',
        label: 'Suggest the group creates a task list before dividing up roles',
        description:
            'Propose a brief planning step to the group before anyone begins working.',
        energyDelta: -10,
        stressDelta: -5,
        focusDelta: 20,
        motivationDelta: 10,
        selfAdvocacyDelta: 10,
        timeMinutesDelta: 65,
        tag: 'initiated_structure',
        educationalFeedback:
            'Introducing structure to an unstructured situation is a coping strategy that benefits both Jordan and the group. Systematic thinkers often bring exactly this kind of value to collaborative work. The effort of speaking up in a group setting — particularly when social dynamics are unclear — is real. When it works, it aligns the environment more closely with Jordan\'s processing style.',
      ),
    ],
  ),
  GameScenario(
    id: 'cafeteria_sensory',
    title: 'Cafeteria Overload',
    timeLabel: '10:00 AM',
    sceneTone: 'class',
    carryoverNotes: {
      'masked_confusing':
          'The extended effort of masking confusion during group work left Jordan\'s sensory tolerance lower than usual. The cafeteria noise hit faster and harder than it might have otherwise.',
    },
    description:
        'The cafeteria is at full volume. Fluorescent lights hum overhead and one section flickers intermittently. Someone nearby is eating something with a strong smell. Chairs scrape on the floor in irregular bursts. Jordan has 30 minutes to eat before the afternoon.',
    narration:
        '"The noise is coming from everywhere at once. I can feel it in my chest and behind my eyes."',
    choices: [
      GameChoice(
        id: 'sit_center_cafeteria',
        label: 'Sit in the center of the cafeteria with classmates',
        description:
            'Join the usual social group, even though the sensory environment is intense.',
        energyDelta: -20,
        stressDelta: 30,
        focusDelta: -15,
        motivationDelta: -10,
        timeMinutesDelta: 30,
        tag: 'masked_lunch',
        educationalFeedback:
            'Remaining in a high-stimulation environment while masking discomfort has a significant cost. Social connection is important, but so is sensory regulation. When the environment exceeds a person\'s current sensory threshold, the body\'s stress response activates regardless of social expectations. The inability to "just ignore it" is not a weakness — it is neurological.',
      ),
      GameChoice(
        id: 'find_quiet_room',
        label: 'Take food to the school\'s quiet study room',
        description:
            'Eat alone in a low-stimulation environment. Study rooms are open for eating during lunch.',
        energyDelta: 15,
        stressDelta: -25,
        focusDelta: 10,
        timeMinutesDelta: 35,
        tag: 'sensory_refuge',
        educationalFeedback:
            'Using a designated quiet space is a form of sensory accommodation. Eating in low-stimulation conditions allowed Jordan\'s nervous system to partially reset during the break. This is not antisocial — it is a necessary form of self-care. When quiet spaces exist at school, they represent a meaningful support for students with sensory sensitivities.',
      ),
      GameChoice(
        id: 'earbuds_edge_seat',
        label:
            'Sit at the edge of the cafeteria with noise-reducing earbuds in',
        description:
            'Use earbuds to reduce audio input while remaining in the shared social space.',
        energyDelta: 5,
        stressDelta: -10,
        focusDelta: 5,
        timeMinutesDelta: 30,
        tag: 'earbuds_strategy',
        educationalFeedback:
            'Using noise-reducing earbuds while eating is a practical sensory strategy. It doesn\'t eliminate all stimulation but meaningfully reduces the most taxing input. Positioning at the edge of the space reduces flanking noise. This reflects the kind of environmental modification many autistic people use independently to stay present in demanding settings.',
      ),
    ],
  ),
  GameScenario(
    id: 'ambiguous_feedback',
    title: 'Vague Feedback',
    timeLabel: '11:15 AM',
    sceneTone: 'class',
    carryoverNotes: {
      'sensory_refuge':
          'The midday quiet reset helped. Jordan arrives at this afternoon period with slightly more processing bandwidth than the morning held.',
      'earbuds_strategy':
          'The earbuds helped keep the afternoon from compounding the morning. Jordan isn\'t fully recovered, but has more left than the cafeteria might have allowed.',
    },
    description:
        'The teacher returns Jordan\'s essay with handwritten comments: "Good start, but needs more development. Push deeper." There is no rubric attached and no specific paragraph is marked. "Deeper" is not defined. The class moves on before Jordan can ask.',
    narration:
        '"I don\'t know what I did wrong. I can\'t fix something when I don\'t know what the problem is."',
    choices: [
      GameChoice(
        id: 'guess_revision',
        label: 'Try to revise the essay by guessing what "deeper" means',
        description:
            'Attempt a revision without clarification, hoping to satisfy the unstated expectation.',
        energyDelta: -20,
        stressDelta: 25,
        focusDelta: -10,
        timeMinutesDelta: 45,
        tag: 'guessed_revision',
        educationalFeedback:
            'Revising without specific feedback requires inferring unstated expectations, which is particularly difficult for autistic students who work most effectively with explicit criteria. The result is high cognitive effort spent on an uncertain target. Even when the revision improves, the lack of clear criteria makes it hard to evaluate success — increasing rather than reducing stress.',
      ),
      GameChoice(
        id: 'ask_teacher_after',
        label: 'Ask the teacher after class for specific, concrete feedback',
        description:
            'Wait until the class ends and ask the teacher to identify exactly what needs to be developed and where.',
        energyDelta: -10,
        stressDelta: -10,
        selfAdvocacyDelta: 20,
        timeMinutesDelta: 60,
        taskCompleted: 'Requested specific, actionable feedback',
        tag: 'asked_specific',
        educationalFeedback:
            'Requesting specific feedback is a skill and a form of self-advocacy. Concrete, criteria-based feedback is more accessible for many autistic learners. Asking for it is not demanding — it is what effective learning often requires. Teachers who respond clearly model that asking is safe, which makes future advocacy easier.',
      ),
      GameChoice(
        id: 'write_questions_wait',
        label:
            'Write down the specific points of confusion and plan to raise them tomorrow',
        description:
            'Note exactly what is unclear before the end of class, and plan to bring those questions to the teacher or a parent.',
        energyDelta: 0,
        stressDelta: -5,
        focusDelta: 5,
        selfAdvocacyDelta: 5,
        timeMinutesDelta: 20,
        educationalFeedback:
            'Writing down specific points of confusion externalizes the problem, which can reduce its cognitive weight. Planning a next step — even when immediate action isn\'t possible — provides a sense of agency. Knowing that the question is recorded and a plan exists is often enough to prevent rumination from consuming the rest of the afternoon.',
      ),
    ],
  ),
  GameScenario(
    id: 'evening_decompression',
    title: 'Final School Hour',
    timeLabel: '2:00 PM',
    endTimeLabel: '3:00 PM',
    sceneTone: 'evening',
    carryoverNotes: {
      'masked_lunch':
          'A full day of masking arrived at the front door with Jordan. By evening, even simple decisions take effort. The special interest isn\'t an escape — it\'s a genuine need.',
    },
    description:
        'The final hour of the school day is beginning. The day involved unexpected changes, social masking, sensory challenges, and ambiguous demands. A mechanical engineering puzzle game — Jordan\'s current special interest — is waiting at home, and homework is due tomorrow.',
    narration:
        '"I just need the game. Everything else can wait — but I know it won\'t."',
    choices: [
      GameChoice(
        id: 'force_homework',
        label: 'Start homework immediately despite feeling completely depleted',
        description:
            'Push through and try to complete all assigned work before resting.',
        energyDelta: -30,
        stressDelta: 25,
        motivationDelta: -20,
        lifeSatisfactionDelta: -15,
        timeMinutesDelta: 60,
        taskCompleted: 'Homework attempted while depleted',
        maxBurnoutAllowed: 70,
        minEnergyRequired: 20,
        unavailableReason:
            'Jordan\'s system is too depleted to produce meaningful work right now. Attempting tasks at this level of exhaustion often results in errors, frustration, and deeper depletion — not completion. Recovery first is not giving up.',
        educationalFeedback:
            'Attempting cognitive work at very high burnout and very low energy often produces poor output and high distress. The homework may technically get done, but at a cost to tomorrow\'s functioning. Recovery is not laziness — it is the prerequisite for future capacity.',
      ),
      GameChoice(
        id: 'special_interest_first',
        label: 'Spend 45 minutes on the puzzle game, then do homework',
        description:
            'Use the special interest to regulate first, then switch to academic demands.',
        energyDelta: 20,
        stressDelta: -25,
        motivationDelta: 25,
        lifeSatisfactionDelta: 20,
        timeMinutesDelta: 60,
        taskCompleted: 'Used special interest for regulated recovery',
        tag: 'special_interest_recovery',
        educationalFeedback:
            'Special interests serve a regulatory function for many autistic people — they are not merely entertainment. Engaging with a preferred topic activates deep motivation, reduces anxiety, and can restore executive function more efficiently than passive rest alone. Using the special interest first, then doing homework, is a valid and sustainable strategy.',
      ),
      GameChoice(
        id: 'one_task_then_rest',
        label: 'Complete only the most urgent task, then rest fully',
        description:
            'Identify the single most critical piece of homework and complete that — nothing else tonight.',
        energyDelta: -5,
        stressDelta: -10,
        motivationDelta: 5,
        lifeSatisfactionDelta: 5,
        timeMinutesDelta: 60,
        taskCompleted: 'Prioritized single task, protected recovery time',
        educationalFeedback:
            'Prioritizing a single essential task and protecting the rest of the evening for recovery is a sustainable strategy. Not everything can or needs to be done every day. Identifying what is most critical and drawing a clear boundary around it is a form of self-regulation that supports longer-term functioning.',
      ),
      GameChoice(
        id: 'full_rest',
        label: 'Complete shutdown — no homework, full rest',
        description:
            'The day has genuinely exceeded capacity. Rest completely. Nothing else tonight.',
        energyDelta: 25,
        stressDelta: -30,
        motivationDelta: 10,
        timeMinutesDelta: 60,
        educationalFeedback:
            'When capacity has genuinely been exceeded, complete rest is often the most responsible option available. Homework done in a shutdown state is rarely retained or produced well. Rest is not giving up — it is what makes tomorrow possible. Recognizing when a full stop is necessary is a sign of self-knowledge, not failure.',
      ),
    ],
  ),
];
