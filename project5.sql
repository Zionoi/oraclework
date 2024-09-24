INSERT INTO fortune (FT_NUM, FORTUNE_TEXT) VALUES (1, '오늘은 중요한 결정이 필요할 수 있습니다. 신중히 생각하세요.');
INSERT INTO fortune (FT_NUM, FORTUNE_TEXT) VALUES (2, '소중한 사람과의 관계가 깊어질 것입니다. 서로의 의견을 존중하세요.');
INSERT INTO fortune (FT_NUM, FORTUNE_TEXT) VALUES (3, '금전적인 면에서 좋은 소식이 있을 수 있습니다. 재정 관리를 철저히 하세요.');
INSERT INTO fortune (FT_NUM, FORTUNE_TEXT) VALUES (4, '건강에 주의가 필요합니다. 규칙적인 운동과 건강한 식습관을 유지하세요.');
INSERT INTO fortune (FT_NUM, FORTUNE_TEXT) VALUES (5, '오늘은 새로운 아이디어가 떠오를 가능성이 큽니다. 창의적인 일을 시도해 보세요.');
INSERT INTO fortune (FT_NUM, FORTUNE_TEXT) VALUES (6, '어려운 상황에 직면할 수 있지만, 긍정적인 마인드로 극복할 수 있을 것입니다.');
INSERT INTO fortune (FT_NUM, FORTUNE_TEXT) VALUES (7, '친구나 가족과 함께 시간을 보내는 것이 좋은 결과를 가져올 것입니다.');
INSERT INTO fortune (FT_NUM, FORTUNE_TEXT) VALUES (8, '직장이나 학업에서 좋은 성과를 기대할 수 있는 날입니다. 최선을 다하세요.');
INSERT INTO fortune (FT_NUM, FORTUNE_TEXT) VALUES (9, '심리적으로 안정된 상태를 유지하는 것이 중요합니다. 스트레스를 줄이세요.');
INSERT INTO fortune (FT_NUM, FORTUNE_TEXT) VALUES (10, '새로운 기회를 만날 가능성이 높습니다. 열린 마음으로 임하세요.');
INSERT INTO fortune (FT_NUM, FORTUNE_TEXT) VALUES (11, '자신의 능력을 믿고 도전해 보세요. 성과가 있을 것입니다.');
INSERT INTO fortune (FT_NUM, FORTUNE_TEXT) VALUES (12, '가족이나 친구와의 대화에서 중요한 정보를 얻을 수 있습니다.');
INSERT INTO fortune (FT_NUM, FORTUNE_TEXT) VALUES (13, '긍정적인 에너지가 넘치는 날입니다. 주변 사람들과의 관계가 좋습니다.');
INSERT INTO fortune (FT_NUM, FORTUNE_TEXT) VALUES (14, '경제적인 결정을 신중히 해야 할 시점입니다. 전문가의 조언을 참고하세요.');
INSERT INTO fortune (FT_NUM, FORTUNE_TEXT) VALUES (15, '오늘은 자신의 목표를 재정립하고 새로운 계획을 세우기에 좋은 날입니다.');
INSERT INTO fortune (FT_NUM, FORTUNE_TEXT) VALUES (16, '창의적인 활동이 잘 풀릴 것입니다. 예술이나 취미 활동에 집중해 보세요.');
INSERT INTO fortune (FT_NUM, FORTUNE_TEXT) VALUES (17, '건강을 위해 충분한 휴식과 수면을 취하세요. 피로가 쌓이지 않도록 주의하세요.');
INSERT INTO fortune (FT_NUM, FORTUNE_TEXT) VALUES (18, '새로운 사람들과의 만남이 기대됩니다. 네트워킹의 기회를 놓치지 마세요.');
INSERT INTO fortune (FT_NUM, FORTUNE_TEXT) VALUES (19, '긍정적인 변화를 경험할 수 있는 날입니다. 새로운 시도를 두려워하지 마세요.');
INSERT INTO fortune (FT_NUM, FORTUNE_TEXT) VALUES (20, '재정적으로 안정된 하루가 될 것입니다. 지출을 계획적으로 하세요.');



SELECT DISTINCT
    REGEXP_SUBSTR(SIGNGU_NM, '^[^ ]+', 1, 1) AS REGION
FROM WALKING_COURSE;