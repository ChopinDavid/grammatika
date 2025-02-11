// TODO(DC): should this be a WordType class? With Verb, Adj, Noun, etc. extending it?
enum WordFormType {
  ruVerbGerundPast,
  ruVerbGerundPresent,
  ruBase,
  ruAdjMNom,
  ruAdjMGen,
  ruAdjMDat,
  ruAdjMAcc,
  ruAdjMInst,
  ruAdjMPrep,
  ruAdjFNom,
  ruAdjFGen,
  ruAdjFDat,
  ruAdjFAcc,
  ruAdjFInst,
  ruAdjFPrep,
  ruAdjNNom,
  ruAdjNGen,
  ruAdjNDat,
  ruAdjNAcc,
  ruAdjNInst,
  ruAdjNPrep,
  ruAdjPlNom,
  ruAdjPlGen,
  ruAdjPlDat,
  ruAdjPlAcc,
  ruAdjPlInst,
  ruAdjPlPrep,
  ruVerbImperativeSg,
  ruVerbImperativePl,
  ruVerbPastM,
  ruVerbPastF,
  ruVerbPastN,
  ruVerbPastPl,
  ruVerbPresfutSg1,
  ruVerbPresfutSg2,
  ruVerbPresfutSg3,
  ruVerbPresfutPl1,
  ruVerbPresfutPl2,
  ruVerbPresfutPl3,
  ruVerbParticipleActivePast,
  ruVerbParticiplePassivePast,
  ruVerbParticipleActivePresent,
  ruVerbParticiplePassivePresent,
  ruNounSgNom,
  ruNounSgGen,
  ruNounSgDat,
  ruNounSgAcc,
  ruNounSgInst,
  ruNounSgPrep,
  ruNounPlNom,
  ruNounPlGen,
  ruNounPlDat,
  ruNounPlAcc,
  ruNounPlInst,
  ruNounPlPrep,
  ruAdjComparative,
  ruAdjSuperlative,
  ruAdjShortM,
  ruAdjShortF,
  ruAdjShortN,
  ruAdjShortPl,
}

extension WordFormTypeExt on WordFormType {
  String get name {
    switch (this) {
      case WordFormType.ruVerbGerundPast:
        return 'ru_verb_gerund_past';
      case WordFormType.ruVerbGerundPresent:
        return 'ru_verb_gerund_present';
      case WordFormType.ruBase:
        return 'ru_base';
      case WordFormType.ruAdjMNom:
        return 'ru_adj_m_nom';
      case WordFormType.ruAdjMGen:
        return 'ru_adj_m_gen';
      case WordFormType.ruAdjMDat:
        return 'ru_adj_m_dat';
      case WordFormType.ruAdjMAcc:
        return 'ru_adj_m_acc';
      case WordFormType.ruAdjMInst:
        return 'ru_adj_m_inst';
      case WordFormType.ruAdjMPrep:
        return 'ru_adj_m_prep';
      case WordFormType.ruAdjFNom:
        return 'ru_adj_f_nom';
      case WordFormType.ruAdjFGen:
        return 'ru_adj_f_gen';
      case WordFormType.ruAdjFDat:
        return 'ru_adj_f_dat';
      case WordFormType.ruAdjFAcc:
        return 'ru_adj_f_acc';
      case WordFormType.ruAdjFInst:
        return 'ru_adj_f_inst';
      case WordFormType.ruAdjFPrep:
        return 'ru_adj_f_prep';
      case WordFormType.ruAdjNNom:
        return 'ru_adj_n_nom';
      case WordFormType.ruAdjNGen:
        return 'ru_adj_n_gen';
      case WordFormType.ruAdjNDat:
        return 'ru_adj_n_dat';
      case WordFormType.ruAdjNAcc:
        return 'ru_adj_n_acc';
      case WordFormType.ruAdjNInst:
        return 'ru_adj_n_inst';
      case WordFormType.ruAdjNPrep:
        return 'ru_adj_n_prep';
      case WordFormType.ruAdjPlNom:
        return 'ru_adj_pl_nom';
      case WordFormType.ruAdjPlGen:
        return 'ru_adj_pl_gen';
      case WordFormType.ruAdjPlDat:
        return 'ru_adj_pl_dat';
      case WordFormType.ruAdjPlAcc:
        return 'ru_adj_pl_acc';
      case WordFormType.ruAdjPlInst:
        return 'ru_adj_pl_inst';
      case WordFormType.ruAdjPlPrep:
        return 'ru_adj_pl_prep';
      case WordFormType.ruVerbImperativeSg:
        return 'ru_verb_imperative_sg';
      case WordFormType.ruVerbImperativePl:
        return 'ru_verb_imperative_pl';
      case WordFormType.ruVerbPastM:
        return 'ru_verb_past_m';
      case WordFormType.ruVerbPastF:
        return 'ru_verb_past_f';
      case WordFormType.ruVerbPastN:
        return 'ru_verb_past_n';
      case WordFormType.ruVerbPastPl:
        return 'ru_verb_past_pl';
      case WordFormType.ruVerbPresfutSg1:
        return 'ru_verb_presfut_sg1';
      case WordFormType.ruVerbPresfutSg2:
        return 'ru_verb_presfut_sg2';
      case WordFormType.ruVerbPresfutSg3:
        return 'ru_verb_presfut_sg3';
      case WordFormType.ruVerbPresfutPl1:
        return 'ru_verb_presfut_pl1';
      case WordFormType.ruVerbPresfutPl2:
        return 'ru_verb_presfut_pl2';
      case WordFormType.ruVerbPresfutPl3:
        return 'ru_verb_presfut_pl3';
      case WordFormType.ruVerbParticipleActivePast:
        return 'ru_verb_participle_active_past';
      case WordFormType.ruVerbParticiplePassivePast:
        return 'ru_verb_participle_passive_past';
      case WordFormType.ruVerbParticipleActivePresent:
        return 'ru_verb_participle_active_present';
      case WordFormType.ruVerbParticiplePassivePresent:
        return 'ru_verb_participle_passive_present';
      case WordFormType.ruNounSgNom:
        return 'ru_noun_sg_nom';
      case WordFormType.ruNounSgGen:
        return 'ru_noun_sg_gen';
      case WordFormType.ruNounSgDat:
        return 'ru_noun_sg_dat';
      case WordFormType.ruNounSgAcc:
        return 'ru_noun_sg_acc';
      case WordFormType.ruNounSgInst:
        return 'ru_noun_sg_inst';
      case WordFormType.ruNounSgPrep:
        return 'ru_noun_sg_prep';
      case WordFormType.ruNounPlNom:
        return 'ru_noun_pl_nom';
      case WordFormType.ruNounPlGen:
        return 'ru_noun_pl_gen';
      case WordFormType.ruNounPlDat:
        return 'ru_noun_pl_dat';
      case WordFormType.ruNounPlAcc:
        return 'ru_noun_pl_acc';
      case WordFormType.ruNounPlInst:
        return 'ru_noun_pl_inst';
      case WordFormType.ruNounPlPrep:
        return 'ru_noun_pl_prep';
      case WordFormType.ruAdjComparative:
        return 'ru_adj_comparative';
      case WordFormType.ruAdjSuperlative:
        return 'ru_adj_superlative';
      case WordFormType.ruAdjShortM:
        return 'ru_adj_short_m';
      case WordFormType.ruAdjShortF:
        return 'ru_adj_short_f';
      case WordFormType.ruAdjShortN:
        return 'ru_adj_short_n';
      case WordFormType.ruAdjShortPl:
        return 'ru_adj_short_pl';
    }
  }

  static WordFormType fromString(String string) {
    switch (string) {
      case 'ru_verb_gerund_past':
        return WordFormType.ruVerbGerundPast;
      case 'ru_verb_gerund_present':
        return WordFormType.ruVerbGerundPresent;
      case 'ru_base':
        return WordFormType.ruBase;
      case 'ru_adj_m_nom':
        return WordFormType.ruAdjMNom;
      case 'ru_adj_m_gen':
        return WordFormType.ruAdjMGen;
      case 'ru_adj_m_dat':
        return WordFormType.ruAdjMDat;
      case 'ru_adj_m_acc':
        return WordFormType.ruAdjMAcc;
      case 'ru_adj_m_inst':
        return WordFormType.ruAdjMInst;
      case 'ru_adj_m_prep':
        return WordFormType.ruAdjMPrep;
      case 'ru_adj_f_nom':
        return WordFormType.ruAdjFNom;
      case 'ru_adj_f_gen':
        return WordFormType.ruAdjFGen;
      case 'ru_adj_f_dat':
        return WordFormType.ruAdjFDat;
      case 'ru_adj_f_acc':
        return WordFormType.ruAdjFAcc;
      case 'ru_adj_f_inst':
        return WordFormType.ruAdjFInst;
      case 'ru_adj_f_prep':
        return WordFormType.ruAdjFPrep;
      case 'ru_adj_n_nom':
        return WordFormType.ruAdjNNom;
      case 'ru_adj_n_gen':
        return WordFormType.ruAdjNGen;
      case 'ru_adj_n_dat':
        return WordFormType.ruAdjNDat;
      case 'ru_adj_n_acc':
        return WordFormType.ruAdjNAcc;
      case 'ru_adj_n_inst':
        return WordFormType.ruAdjNInst;
      case 'ru_adj_n_prep':
        return WordFormType.ruAdjNPrep;
      case 'ru_adj_pl_nom':
        return WordFormType.ruAdjPlNom;
      case 'ru_adj_pl_gen':
        return WordFormType.ruAdjPlGen;
      case 'ru_adj_pl_dat':
        return WordFormType.ruAdjPlDat;
      case 'ru_adj_pl_acc':
        return WordFormType.ruAdjPlAcc;
      case 'ru_adj_pl_inst':
        return WordFormType.ruAdjPlInst;
      case 'ru_adj_pl_prep':
        return WordFormType.ruAdjPlPrep;
      case 'ru_verb_imperative_sg':
        return WordFormType.ruVerbImperativeSg;
      case 'ru_verb_imperative_pl':
        return WordFormType.ruVerbImperativePl;
      case 'ru_verb_past_m':
        return WordFormType.ruVerbPastM;
      case 'ru_verb_past_f':
        return WordFormType.ruVerbPastF;
      case 'ru_verb_past_n':
        return WordFormType.ruVerbPastN;
      case 'ru_verb_past_pl':
        return WordFormType.ruVerbPastPl;
      case 'ru_verb_presfut_sg1':
        return WordFormType.ruVerbPresfutSg1;
      case 'ru_verb_presfut_sg2':
        return WordFormType.ruVerbPresfutSg2;
      case 'ru_verb_presfut_sg3':
        return WordFormType.ruVerbPresfutSg3;
      case 'ru_verb_presfut_pl1':
        return WordFormType.ruVerbPresfutPl1;
      case 'ru_verb_presfut_pl2':
        return WordFormType.ruVerbPresfutPl2;
      case 'ru_verb_presfut_pl3':
        return WordFormType.ruVerbPresfutPl3;
      case 'ru_verb_participle_active_past':
        return WordFormType.ruVerbParticipleActivePast;
      case 'ru_verb_participle_passive_past':
        return WordFormType.ruVerbParticiplePassivePast;
      case 'ru_verb_participle_active_present':
        return WordFormType.ruVerbParticipleActivePresent;
      case 'ru_verb_participle_passive_present':
        return WordFormType.ruVerbParticiplePassivePresent;
      case 'ru_noun_sg_nom':
        return WordFormType.ruNounSgNom;
      case 'ru_noun_sg_gen':
        return WordFormType.ruNounSgGen;
      case 'ru_noun_sg_dat':
        return WordFormType.ruNounSgDat;
      case 'ru_noun_sg_acc':
        return WordFormType.ruNounSgAcc;
      case 'ru_noun_sg_inst':
        return WordFormType.ruNounSgInst;
      case 'ru_noun_sg_prep':
        return WordFormType.ruNounSgPrep;
      case 'ru_noun_pl_nom':
        return WordFormType.ruNounPlNom;
      case 'ru_noun_pl_gen':
        return WordFormType.ruNounPlGen;
      case 'ru_noun_pl_dat':
        return WordFormType.ruNounPlDat;
      case 'ru_noun_pl_acc':
        return WordFormType.ruNounPlAcc;
      case 'ru_noun_pl_inst':
        return WordFormType.ruNounPlInst;
      case 'ru_noun_pl_prep':
        return WordFormType.ruNounPlPrep;
      case 'ru_adj_comparative':
        return WordFormType.ruAdjComparative;
      case 'ru_adj_superlative':
        return WordFormType.ruAdjSuperlative;
      case 'ru_adj_short_m':
        return WordFormType.ruAdjShortM;
      case 'ru_adj_short_f':
        return WordFormType.ruAdjShortF;
      case 'ru_adj_short_n':
        return WordFormType.ruAdjShortN;
      case 'ru_adj_short_pl':
        return WordFormType.ruAdjShortPl;
      default:
        throw Exception('String id did not match any WordFormType.');
    }
  }

  String get displayName {
    switch (this) {
      case WordFormType.ruVerbGerundPast:
        return 'Gerund Past';
      case WordFormType.ruVerbGerundPresent:
        return 'Gerund Present';
      case WordFormType.ruBase:
        return 'Base';
      case WordFormType.ruAdjMNom:
        return 'Adjective Masculine Nominative';
      case WordFormType.ruAdjMGen:
        return 'Adjective Masculine Genitive';
      case WordFormType.ruAdjMDat:
        return 'Adjective Masculine Dative';
      case WordFormType.ruAdjMAcc:
        return 'Adjective Masculine Accusative';
      case WordFormType.ruAdjMInst:
        return 'Adjective Masculine Instrumental';
      case WordFormType.ruAdjMPrep:
        return 'Adjective Masculine Prepositional';
      case WordFormType.ruAdjFNom:
        return 'Adjective Feminine Nominative';
      case WordFormType.ruAdjFGen:
        return 'Adjective Feminine Genitive';
      case WordFormType.ruAdjFDat:
        return 'Adjective Feminine Dative';
      case WordFormType.ruAdjFAcc:
        return 'Adjective Feminine Accusative';
      case WordFormType.ruAdjFInst:
        return 'Adjective Feminine Instrumental';
      case WordFormType.ruAdjFPrep:
        return 'Adjective Feminine Prepositional';
      case WordFormType.ruAdjNNom:
        return 'Adjective Neuter Nominative';
      case WordFormType.ruAdjNGen:
        return 'Adjective Neuter Genitive';
      case WordFormType.ruAdjNDat:
        return 'Adjective Neuter Dative';
      case WordFormType.ruAdjNAcc:
        return 'Adjective Neuter Accusative';
      case WordFormType.ruAdjNInst:
        return 'Adjective Neuter Instrumental';
      case WordFormType.ruAdjNPrep:
        return 'Adjective Noun Prepositional';
      case WordFormType.ruAdjPlNom:
        return 'Adjective Plural Nominative';
      case WordFormType.ruAdjPlGen:
        return 'Adjective Plural Genitive';
      case WordFormType.ruAdjPlDat:
        return 'Adjective Plural Dative';
      case WordFormType.ruAdjPlAcc:
        return 'Adjective Plural Accusative';
      case WordFormType.ruAdjPlInst:
        return 'Adjective Plural Instrumental';
      case WordFormType.ruAdjPlPrep:
        return 'Adjective Plural Prepositional';
      case WordFormType.ruVerbImperativeSg:
        return 'Verb Imperative Singular';
      case WordFormType.ruVerbImperativePl:
        return 'Verb Imperative Plural';
      case WordFormType.ruVerbPastM:
        return 'Verb Masculine Past';
      case WordFormType.ruVerbPastF:
        return 'Verb Feminine Past';
      case WordFormType.ruVerbPastN:
        return 'Verb Neuter Past';
      case WordFormType.ruVerbPastPl:
        return 'Verb Plural Past';
      case WordFormType.ruVerbPresfutSg1:
        return 'Verb First Person Singular';
      case WordFormType.ruVerbPresfutSg2:
        return 'Verb Second Person Singular';
      case WordFormType.ruVerbPresfutSg3:
        return 'Verb Third Person Singular';
      case WordFormType.ruVerbPresfutPl1:
        return 'Verb First Person Plural';
      case WordFormType.ruVerbPresfutPl2:
        return 'Verb Second Person Plural';
      case WordFormType.ruVerbPresfutPl3:
        return 'Verb Third Person Plural';
      case WordFormType.ruVerbParticipleActivePast:
        return 'Verb Past Active Participle';
      case WordFormType.ruVerbParticiplePassivePast:
        return 'Verb Past Passive Participle';
      case WordFormType.ruVerbParticipleActivePresent:
        return 'Verb Present Active Participle';
      case WordFormType.ruVerbParticiplePassivePresent:
        return 'Verb Present Passive Participle';
      case WordFormType.ruNounSgNom:
        return 'Noun Singular Nominative';
      case WordFormType.ruNounSgGen:
        return 'Noun Singular Genitive';
      case WordFormType.ruNounSgDat:
        return 'Noun Singular Dative';
      case WordFormType.ruNounSgAcc:
        return 'Noun Singular Accusative';
      case WordFormType.ruNounSgInst:
        return 'Noun Singular Instrumental';
      case WordFormType.ruNounSgPrep:
        return 'Noun Singular Prepositional';
      case WordFormType.ruNounPlNom:
        return 'Noun Plural Nominative';
      case WordFormType.ruNounPlGen:
        return 'Noun Plural Genitive';
      case WordFormType.ruNounPlDat:
        return 'Noun Plural Dative';
      case WordFormType.ruNounPlAcc:
        return 'Noun Plural Accusative';
      case WordFormType.ruNounPlInst:
        return 'Noun Plural Instrumental';
      case WordFormType.ruNounPlPrep:
        return 'Noun Plural Prepositional';
      case WordFormType.ruAdjComparative:
        return 'Adjective Comparative';
      case WordFormType.ruAdjSuperlative:
        return 'Adjective Superlative';
      case WordFormType.ruAdjShortM:
        return 'Adjective Masculine';
      case WordFormType.ruAdjShortF:
        return 'Adjective Short Feminine';
      case WordFormType.ruAdjShortN:
        return 'Adjective Short Neuter';
      case WordFormType.ruAdjShortPl:
        return 'Adjective Short Plural';
    }
  }
}
