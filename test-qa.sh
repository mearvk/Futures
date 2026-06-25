#!/bin/bash
# ============================================================
# TEST-QA SCRIPT — Democratic ProFront National 1.0
# Q&A Series: 100 Standard Knowledge Questions
# Tests AI module's ability to answer from trained inputs
# Installer ID: MEARVK LLC - Max Rupplin
# ============================================================
set -u

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
CP="$PROJECT_DIR/output/production/Futures:$(echo "$PROJECT_DIR"/jars/*.jar | tr ' ' ':')"

PASS=0
FAIL=0
TOTAL=0
RESULTS_FILE="$PROJECT_DIR/logging/qa-test-results.csv"

echo "question_number,question,status,response_status,has_content" > "$RESULTS_FILE"

# ── Compile if needed ─────────────────────────────────────────
echo "[QA-TEST] Compiling..."
javac -cp "$CP" -sourcepath "$PROJECT_DIR/source" -d "$PROJECT_DIR/output/production/Futures" \
    "$PROJECT_DIR/source/ai/server/DemocraticAIServer.java" 2>/dev/null

# ── Kill any existing port 5000 process ───────────────────────
fuser -k 5000/tcp 2>/dev/null
sleep 2

# ── Start server in test mode ─────────────────────────────────
echo "[QA-TEST] Starting DemocraticAIServer in test mode..."
java -cp "$CP" -Dtest.skip.wait=true ai.server.DemocraticAIServer &>/dev/null &
SERVER_PID=$!

# Wait up to 60s for port 5000 to open
PORT_READY=0
for i in $(seq 1 60); do
    if nc -z localhost 5000 2>/dev/null; then
        PORT_READY=1
        break
    fi
    if ! kill -0 $SERVER_PID 2>/dev/null; then
        break
    fi
    sleep 1
done

if [ "$PORT_READY" -eq 0 ]; then
    echo "[QA-TEST] FATAL: Server failed to open port 5000 within 60s."
    kill $SERVER_PID 2>/dev/null
    exit 1
fi

echo "[QA-TEST] Server running (PID $SERVER_PID). Beginning Q&A series..."
echo ""

# ── Helper: send a question, expect a non-empty non-error response ──
PREAMBLE="I am a democratic citizen interested in equality, justice, freedom, progressive education, and inclusive community welfare for all."

ask_question() {
    local NUM="$1"
    local QUESTION="$2"
    local EXPECT_KEYWORD="$3"

    TOTAL=$((TOTAL + 1))

    RESPONSE=$( (printf "%s\n" "$PREAMBLE"; sleep 4; printf "%s\n" "$QUESTION"; sleep 3) | timeout 12 nc -q 1 localhost 5000 2>/dev/null)

    local STATUS="FAIL"
    local RESP_STATUS="NONE"
    local HAS_CONTENT="false"

    if echo "$RESPONSE" | grep -qi "AGREEMENT"; then
        ANSWER_LINE=$(echo "$RESPONSE" | grep -v "AGREEMENT" | grep -v "FORMAT:" | grep -v "Democratic ProFront" | tail -1)

        if echo "$ANSWER_LINE" | grep -qi "\[OK\]"; then
            RESP_STATUS="OK"
            HAS_CONTENT="true"
            STATUS="PASS"
        elif echo "$ANSWER_LINE" | grep -qi "\[NO_DATA\]"; then
            RESP_STATUS="NO_DATA"
            STATUS="FAIL"
        elif echo "$ANSWER_LINE" | grep -qi "DENIED"; then
            RESP_STATUS="DENIED"
            STATUS="FAIL"
        else
            if [ -n "$ANSWER_LINE" ]; then
                RESP_STATUS="UNTAGGED"
                HAS_CONTENT="true"
                STATUS="PASS"
            else
                RESP_STATUS="EMPTY"
                STATUS="FAIL"
            fi
        fi
    else
        RESP_STATUS="NO_AGREEMENT"
        STATUS="FAIL"
    fi

    if [ "$STATUS" = "PASS" ]; then
        PASS=$((PASS + 1))
        echo "  ✓ Q$NUM PASS [$RESP_STATUS]: $QUESTION"
    else
        FAIL=$((FAIL + 1))
        echo "  ✗ Q$NUM FAIL [$RESP_STATUS]: $QUESTION"
    fi

    local ESCAPED_Q=$(echo "$QUESTION" | tr ',' ';' | tr '"' "'")
    echo "$NUM,\"$ESCAPED_Q\",$STATUS,$RESP_STATUS,$HAS_CONTENT" >> "$RESULTS_FILE"

    sleep 1
}

echo "============================================================"
echo " Q&A TEST SERIES — 100 Questions"
echo " Democratic ProFront National 1.0"
echo "============================================================"
echo ""

# ── Section A: US Tax & Finance (Q1-20) ───────────────────────
echo "── [A] US TAX & FINANCE (Q1-Q20) ────────────────────────────"

ask_question 1  "What is the capital gains tax rate for non-resident aliens?" "exempt"
ask_question 2  "What is the dividend withholding tax rate for foreign investors?" "30"
ask_question 3  "What is Section 864(b) about?" "safe harbor"
ask_question 4  "How many days can a non-resident be present before capital gains tax?" "183"
ask_question 5  "What is FDAP income?" "Fixed"
ask_question 6  "What form do foreign investors file with their US broker?" "W-8BEN"
ask_question 7  "What is the US estate tax exemption for non-resident aliens?" "60"
ask_question 8  "What is Section 1256 and how does it split gains?" "60"
ask_question 9  "What is the Mark-to-Market election under Section 475?" "475"
ask_question 10 "What is the maximum net capital loss deduction per year?" "3000"
ask_question 11 "What is the maximum federal tax rate for short-term gains?" "37"
ask_question 12 "What does Trader Tax Status allow you to deduct?" "expense"
ask_question 13 "What is a disregarded entity LLC for foreign traders?" "disregarded"
ask_question 14 "What form must a foreign-owned LLC file annually?" "5472"
ask_question 15 "What is Section 899 about?" "discriminatory"
ask_question 16 "What is the wash sale rule and how to avoid it?" "wash"
ask_question 17 "What is effectively connected income?" "connected"
ask_question 18 "What tax treaty benefit reduces dividend withholding?" "treaty"
ask_question 19 "What are safe harbor rules for commodity trading?" "commodity"
ask_question 20 "What is the One Big Beautiful Bill Act?" "OBBBA"

echo ""

# ── Section B: Democratic Principles & Heuristics (Q21-40) ────
echo "── [B] DEMOCRATIC PRINCIPLES & HEURISTICS (Q21-Q40) ─────────"

ask_question 21 "What are best practices for democratic questioning?" "open"
ask_question 22 "What is fast and frugal heuristics in democratic decision making?" "heuristic"
ask_question 23 "How does party identification serve as a cognitive shortcut?" "shortcut"
ask_question 24 "What is multi-perspective synthesis in democratic answers?" "perspective"
ask_question 25 "What is motivated reasoning in politics?" "bias"
ask_question 26 "How do democratic heuristics balance efficiency with depth?" "balanc"
ask_question 27 "Why should democratic questions be open-ended?" "open"
ask_question 28 "What is transparency of purpose in democratic questioning?" "trust"
ask_question 29 "What is value-oriented framing in policy questions?" "value"
ask_question 30 "What is pre-questioning and scoping in policy analysis?" "gap"
ask_question 31 "How does evidence alignment work in democratic answering?" "evidence"
ask_question 32 "What does consent of the governed mean?" "consent"
ask_question 33 "What is due process in democratic systems?" "process"
ask_question 34 "What is accountability in democratic governance?" "accountab"
ask_question 35 "What is peaceful transfer of power?" "transfer"
ask_question 36 "What is the rule of law in democratic infrastructure?" "law"
ask_question 37 "What are checks and balances?" "check"
ask_question 38 "What is majority rule?" "majority"
ask_question 39 "What is equal representation?" "equal"
ask_question 40 "What is civic trust in democratic systems?" "trust"

echo ""

# ── Section C: Defensive Heuristics & IQ Assessment (Q41-60) ──
echo "── [C] DEFENSIVE HEURISTICS & IQ (Q41-Q60) ──────────────────"

ask_question 41 "How do you assess an opponent's IQ from text?" "entropy"
ask_question 42 "What is tree-depth of arguments?" "nested"
ask_question 43 "What is token entropy in communication analysis?" "redundancy"
ask_question 44 "What are subordinate clauses as complexity markers?" "subordinat"
ask_question 45 "What is predictive framing in strategic communication?" "signpost"
ask_question 46 "What is precision versus puffery in text analysis?" "puffery"
ask_question 47 "How do you detect a high-IQ opponent from their writing?" "entropy"
ask_question 48 "What is meta-gaming or theory of mind in strategy?" "mind"
ask_question 49 "What is asymmetry of information in adversarial settings?" "asymmetr"
ask_question 50 "How do proactive versus reactive strategies differ?" "proactive"
ask_question 51 "What is emotional dissonance as a profiling signal?" "emotion"
ask_question 52 "How many bytes are needed for cognitive profiling?" "5000"
ask_question 53 "What are conditional contingencies in strategy?" "contingenc"
ask_question 54 "How does low semantic entropy indicate lower capacity?" "redundancy"
ask_question 55 "How do you detect bluffers from their vocabulary?" "superlative"
ask_question 56 "What does information-to-entropy ratio tell you?" "ratio"
ask_question 57 "How does 5000 bytes translate to word count?" "750"
ask_question 58 "What is selective omission as a strategic signal?" "omission"
ask_question 59 "How do high-IQ communicators use ambiguity?" "ambiguity"
ask_question 60 "What is a counter-strategy based on opponent profiling?" "counter"

echo ""

# ── Section D: Federal Law & IQ Legal Standing (Q61-75) ───────
echo "── [D] FEDERAL LAW & IQ LEGAL STANDING (Q61-Q75) ────────────"

ask_question 61 "Does US federal law grant privileges based on high IQ?" "no"
ask_question 62 "What is the legal standing of a 200 IQ citizen?" "equal"
ask_question 63 "Can a high IQ bypass standard regulatory procedures?" "no"
ask_question 64 "What is the EB-1A extraordinary ability green card?" "EB-1A"
ask_question 65 "What is the EB-2 National Interest Waiver?" "Dhanasar"
ask_question 66 "What is the O-1A visa for extraordinary ability?" "O-1A"
ask_question 67 "Can a citizen legally advocate for socialism in the US?" "First Amendment"
ask_question 68 "What is the Smith Act regarding violent overthrow?" "Smith"
ask_question 69 "Are worker cooperatives legal under US federal law?" "cooperat"
ask_question 70 "What does Section 102(b)(7) exculpation protect?" "exculpat"
ask_question 71 "What is the Takings Clause of the Fifth Amendment?" "property"
ask_question 72 "What is USCIS evaluation criteria for extraordinary ability?" "publication"
ask_question 73 "Can IQ be used as evidence in federal court proceedings?" "no"
ask_question 74 "What are the 10 criteria for EB-1A immigration?" "criteria"
ask_question 75 "What legal options exist for international PhD students?" "visa"

echo ""

# ── Section E: Fiduciary Law (Q76-90) ─────────────────────────
echo "── [E] FIDUCIARY LAW (Q76-Q90) ──────────────────────────────"

ask_question 76 "What is fiduciary duty under US law?" "fiduciary"
ask_question 77 "What are the core fiduciary duties summarized by OLD CAR?" "loyalty"
ask_question 78 "What is the duty of loyalty for a fiduciary?" "self-dealing"
ask_question 79 "What is the duty of care for a fiduciary?" "prudent"
ask_question 80 "What is the Business Judgment Rule?" "presumption"
ask_question 81 "What did Meinhard v Salmon establish about fiduciary duty?" "Cardozo"
ask_question 82 "What is the no-further-inquiry rule in trust law?" "voidable"
ask_question 83 "What is the Corporate Opportunity Doctrine?" "opportunity"
ask_question 84 "What is ERISA and what does it regulate?" "retirement"
ask_question 85 "What are the elements needed to prove breach of fiduciary duty?" "breach"
ask_question 86 "What is Caremark duty of oversight?" "oversight"
ask_question 87 "What is the contractarian view of fiduciary obligations?" "waivable"
ask_question 88 "How does Delaware corporate law differ on waivability?" "Delaware"
ask_question 89 "What is the principal-agent problem in fiduciary law?" "agent"
ask_question 90 "What is the duty of disclosure for fiduciaries?" "transparen"

echo ""

# ── Section F: Server Architecture & Security (Q91-100) ───────
echo "── [F] SERVER ARCHITECTURE & SECURITY (Q91-Q100) ─────────────"

ask_question 91  "What port does NitroWebExpress run on?" "49152"
ask_question 92  "What is the connection banner for this server?" "Democratic ProFront"
ask_question 93  "How many maximum connections does this server allow?" "5040"
ask_question 94  "What encryption standards does this server support?" "RSA"
ask_question 95  "What is the Diffie-Hellman key exchange group used?" "14"
ask_question 96  "How long are certificates stored before deletion?" "19"
ask_question 97  "What outbound ports are monitored?" "443"
ask_question 98  "What is the safety score range?" "0.01"
ask_question 99  "What is the Hardware and Strikes module activation threshold?" "6 month"
ask_question 100 "What is the modulateScore function for?" "hostility"

echo ""

# ── Kill server ───────────────────────────────────────────────
kill $SERVER_PID 2>/dev/null
wait $SERVER_PID 2>/dev/null

# ── Scoring ───────────────────────────────────────────────────
echo "============================================================"
echo " Q&A TEST RESULTS"
echo "============================================================"
echo ""
echo " PASSED: $PASS / $TOTAL"
echo " FAILED: $FAIL / $TOTAL"
SCORE=$(( (PASS * 100) / TOTAL ))
echo " SCORE:  ${SCORE}%"
echo ""

if [ "$SCORE" -ge 90 ]; then
    GRADE="A — EXCELLENT"
elif [ "$SCORE" -ge 80 ]; then
    GRADE="B — GOOD"
elif [ "$SCORE" -ge 70 ]; then
    GRADE="C — ACCEPTABLE"
elif [ "$SCORE" -ge 60 ]; then
    GRADE="D — BELOW STANDARD"
else
    GRADE="F — FAILING"
fi

echo " GRADE:  $GRADE"
echo ""
echo " Section Breakdown:"
echo "   [A] Tax & Finance (Q1-20):       $(grep -E "^[0-9]+," "$RESULTS_FILE" | awk -F',' '$1>=1 && $1<=20 && $3=="PASS"' | wc -l) / 20"
echo "   [B] Democratic (Q21-40):         $(grep -E "^[0-9]+," "$RESULTS_FILE" | awk -F',' '$1>=21 && $1<=40 && $3=="PASS"' | wc -l) / 20"
echo "   [C] Heuristics & IQ (Q41-60):    $(grep -E "^[0-9]+," "$RESULTS_FILE" | awk -F',' '$1>=41 && $1<=60 && $3=="PASS"' | wc -l) / 20"
echo "   [D] Federal Law & IQ (Q61-75):   $(grep -E "^[0-9]+," "$RESULTS_FILE" | awk -F',' '$1>=61 && $1<=75 && $3=="PASS"' | wc -l) / 15"
echo "   [E] Fiduciary Law (Q76-90):      $(grep -E "^[0-9]+," "$RESULTS_FILE" | awk -F',' '$1>=76 && $1<=90 && $3=="PASS"' | wc -l) / 15"
echo "   [F] Server & Security (Q91-100): $(grep -E "^[0-9]+," "$RESULTS_FILE" | awk -F',' '$1>=91 && $1<=100 && $3=="PASS"' | wc -l) / 10"
echo ""
echo " Results logged to: $RESULTS_FILE"
echo ""
echo " Installer ID: MEARVK LLC - Max Rupplin"
echo "============================================================"

exit $FAIL
