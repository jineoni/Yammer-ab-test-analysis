## A/B Test Validation — Publisher Feature Analysis

This project evaluates the validity of an A/B test conducted for the “publisher” feature on Yammer.  
Although the initial test showed a 50% increase in posting rate for the treatment group, further investigation was required to determine whether the result reflected true impact or experimental bias.

**Project Duration:** 1 month  
**Reference:** https://mode.com/sql-tutorial/validating-ab-test-results

---

### 1. Problem Statement

Yammer ran an A/B test from **June 1 to June 30** to assess an update to its publisher interface.  
**Initial finding:**  
- Treatment group posted **50% more messages** than the control group.

**Objective:**  
Determine whether this increase represents a true treatment effect or a misleading artifact caused by assignment or data issues.

---

### 2. Initial A/B Test Results

The treatment group showed a significantly higher average message count.  
However, the unusually large difference warranted deeper investigation.

---

### 3. Investigation & Validation Steps

#### 3.1 User Assignment Issues

During data exploration, all newly registered users in June were found to be **assigned only to the control group**.

Implications:
- New users typically post less due to unfamiliarity with the platform.
- This creates a **non-random assignment**, violating A/B test validity.
- Analyses should consider **existing vs. new users separately**.

**Revised Analysis (Existing Users Only):**
- However, the difference remained **statistically significant**, indicating a real effect beyond assignment bias.

---

#### 3.2 Checking Additional Metrics

To ensure the improvement was not isolated or caused by a bug, additional behavioral metrics were examined.

##### a. Login Frequency
- Treatment users logged in more frequently.
- The difference was statistically significant.
- Indicates increased engagement beyond content posting.

##### b. Unique Usage Days
- Evaluated to ensure users weren’t logging in/out rapidly due to a bug.
- Treatment group exhibited higher unique usage days.
- **p-value < 0.05**, supporting a true behavioral shift.

---

#### 3.3 Device-Type Analysis

To rule out device-specific anomalies:
- Usage patterns were compared across device types.
- The feature effect was **consistent**, showing no device-driven bias.
- Further study may be needed for subtle device-related behavioral differences.

---

### 4. Conclusion

#### Effectiveness of the Update
- The publisher update likely improved overall user engagement.
- Increased:
  - Posting rates  
  - Login frequency  
  - Distinct usage days  
- Suggests a **positive and robust user experience improvement**.

#### Limitations & Concerns
- **Non-random assignment** of new users undermines strict experiment validity.
- Engagement differences between new and existing users require separate modeling.
- Future tests should:
  - Enforce true randomization  
  - Stratify or segment users by tenure  
  - Include device-type and time-period controls  

---

### 5. Key Learnings

- A/B test results must be validated beyond surface-level differences.  
- Investigating **assignment, segmentation, and behavioral metrics** is essential for reliable conclusions.  
- Even statistically significant findings can mask underlying methodological issues.  
- Proper experimental design and monitoring prevent misinterpretation of results.
