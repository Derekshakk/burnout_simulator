/// Hardcoded testimonial content for the Testimonials page.
///
/// Wording is reproduced faithfully from the sources and must not be
/// paraphrased or summarized. The featured entry comes from Project Ignite's
/// own testimonials form; the remaining entries are sourced high-school
/// student testimonials (ADHD/ASD and burnout) and keep their original
/// usernames. See [testimonialsSourceNote] for attribution of the latter.
library;

/// A single testimonial: an attribution label and one or more faithful
/// paragraphs of the person's own words.
class Testimonial {
  /// How the entry is attributed (e.g. "From our testimonials form" or a
  /// source username). Never a fabricated real name.
  final String attribution;

  /// The quote, split into paragraphs exactly as written in the source.
  final List<String> paragraphs;

  /// Whether this is the featured (Project Ignite form) testimonial.
  final bool featured;

  const Testimonial({
    required this.attribution,
    required this.paragraphs,
    this.featured = false,
  });
}

/// Attribution for the externally sourced testimonials below.
const String testimonialsSourceNote =
    "Source: High School Student Testimonials from students who have ADHD/ASD "
    "and faced burnout in school.";

/// The featured testimonial submitted through Project Ignite's own form.
/// It is intentionally unattributed to a name.
const Testimonial featuredTestimonial = Testimonial(
  attribution: "From our testimonials form",
  featured: true,
  paragraphs: [
    "Autistic burnout for me is a much more intense version of burnout. As in "
        "I can't eat or make myself food, or buy groceries, or clean up my "
        "living space. It's like not having energy to live but distinct from "
        "depression: I WANT to do all those things because I know I need to but "
        "I simply can't. Autistic burnout is a natural result of living in a "
        "neuronormative world with the expectations demanded by neurotypical "
        "individuals. Masking 24/7 especially contributes to burnout building "
        "up every day. Something that helps heal burnout is doing "
        "hyperfixation or special interest activities, reducing workloads, "
        "reducing external stimulation with lights, sounds, etc, and time. So "
        "much time.",
  ],
);

/// Externally sourced student testimonials. Usernames are preserved verbatim.
const List<Testimonial> sourcedTestimonials = [
  Testimonial(
    attribution: "No-Willow-1217",
    paragraphs: [
      "I totally burned out by sophomore year. I was constantly late, would "
          "miss the bus and needed to walk a mile to school because my parents "
          "were at work. I just couldn't fall asleep at a decent hour, and my "
          "sleep wasn't enough, would fall asleep in class in the morning "
          "constantly. My grades were tanking after being a solid A and B "
          "student. I thought I was just depressed; this was the early 90s, and "
          "you didn't get medicated unless you were suicidal. ADHD wasn't "
          "really a thing either, never even heard of it. I tried to ask for "
          "help from a social worker and they asked about my grades and stuff "
          "and they called my mom and i don't know what she said but they "
          "ganged up on me and told me I was lazy and i needed to get my butt "
          "whipped for being lazy. The 90s.",
    ],
  ),
  Testimonial(
    attribution: "TShara_Q",
    paragraphs: [
      "I definitely missed classes, especially my senior year. I just couldn't "
          "bring myself to do anything on time without procrastinating. So I "
          "would skip school to finish projects or because I burned myself out "
          "finishing them the night before.",
      "The morning I finished one big project, I had a meltdown in the car on "
          "the way to school. I think I started yelling and sobbing because I "
          "spilled my coffee or something. My dad told me to turn in the "
          "project and then come back to the car to go home. He was afraid I "
          "would get myself in trouble freaking out on no sleep to a classmate "
          "or teacher. Honestly, it's one of the better parenting decisions he "
          "made.",
      "I'm not proud of it. I was undiagnosed and unmedicated at the time, "
          "plus I was dealing with teenage hormones and depression.",
    ],
  ),
  Testimonial(
    attribution: "undefined_protocol",
    paragraphs: [
      "The biggest thing that I wish was different is that I wish I understood "
          "that breaking down didn't make me a bad person.",
      "I was hitting my limit and cutting class 2-3x a week on average. I hated "
          "myself for not being able to keep up. I wish I understood how tired "
          "I was.",
    ],
  ),
];
