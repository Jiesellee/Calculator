// STEP 1 - Add your username here
// this holds all users format: firstnamelastname
// right now we can't delete users from this list, instead change the username to donotdeleteme1 etc
// we should either wait for richer interpolation in terraform, but ultimately use Single sign on and SAML
// add yourself to the end of the list
module "iam_root_account" {
  source = "../../../modules/iam_root_account"

  users = [
    "donotdeletemews",
    "chrisharding",
    "donotdeletemeF3846",
    "davidtedwards",
    "donotdeletemesim",
    "donotdeleteme1",
    "donotdeleteme2",
    "martingallagher",
    "nimahlganesh",
    "donotdeleteme3",
    "willperkins",
    "mikesmart",
    "donotdeleteme6",
    "charleswilkinson",
    "arjunmakineni",
    "malonieguha",
    "mikecharles",
    "atanaskanchev",
    "donotdeleteme",
    "ruaanventer",
    "donotdeletemeD3a0",
    "donotdeletemehit",
    "pritvirajmanoharan",
    "prashantramcharan",
    "amitkumar",
    "poojababurajan",
    "donotdeleteme5",
    "rinkupoptani",
    "manojjose",
    "tomrobson",
    "richardlloyd",
    "stefancocora",
    "sarojraut",
    "chriswheelhouse",
    "donotdeleteme7",
    "keerthikrishnamurthy",
    "donotdeleteme4",
    "dandillingham",
    "donotdeletemeFRDS",
    "bendavies",
    "alantyler",
    "chrisjaques",
    "donotdeletemecp",
    "sabbirahmed",
    "adrianchristian",
    "bamdaddashtban",
    "robertjoscelyne",
    "sarikasharma",
    "caitlingulliford",
    "mariopaphitis",
    "pauloschneider",
    "patrickoladimeji",
    "vicencgarcia",
    "javiergomez",
    "andreabianchi",
    "rajaharumugam",
    "donotdeletemebs",
    "benprudence",
    "aaronphilbertchedick",
    "kawahcheung",
    "matthewwoodruff",
    "vedavallikanala",
    "sergetanpanza",
    "marylrodrigues",
    "babitharakesh",
    "donotdeletemeMGT123",
    "danwilliams",
    "mariogiamp",
    "fergusorbach",
    "vincentdavies",
    "keithdevlin",
    "mirceamoise",
    "daryakostenko",
    "deletedianroberts",
    "donotdeletemeABC789",
    "deletedparis",
    "parisgoudas",
    "linaalagrami",
    "ianroberts",
    "dougjeffery",
    "chandreshpatel",
    "jiesellebokodi", 
]

  // STEP 2 - Add your username and pgp key here!
  // these are used to encrypt your dynamically generated password for you to fetch through
  // the output of terraform in CI after merge
  // you can specify a pgp public key string, or a keybase username which is preferred (willejs has invites!)
  users_pgp_keys = {
    donotdeletemews      = "${var.dummy_pgp_key}"
    chrisharding         = "keybase:chrisjharding"
    donotdeletemeF3846   = "${var.dummy_pgp_key}"
    davidtedwards        = "keybase:davidtedwards"
    donotdeletemesim     = "${var.dummy_pgp_key}"
    donotdeleteme1       = "keybase:crossing"
    donotdeleteme2       = "${var.dummy_pgp_key}"
    donotdeleteme3       = "${var.dummy_pgp_key}"
    donotdeleteme4       = "${var.dummy_pgp_key}"
    donotdeleteme5       = "${var.dummy_pgp_key}"
    donotdeleteme6       = "${var.dummy_pgp_key}"
    martingallagher      = "keybase:martingallagher"
    nimahlganesh         = "keybase:nimahlg"
    willperkins          = "keybase:perkimon"
    mikesmart            = "keybase:pocketrocket64"
    charleswilkinson     = "keybase:kabadisha"
    arjunmakineni        = "keybase:arjunmakineni"
    malonieguha          = "keybase:malonieguha"
    mikecharles          = "keybase:mikecharles"
    atanaskanchev        = "keybase:atanaskanchevri"
    donotdeleteme        = "keybase:markrichardsri"
    ruaanventer          = "keybase:ruaanv"
    donotdeletemeD3a0    = "${var.dummy_pgp_key}"
    donotdeletemehit     = "${var.dummy_pgp_key}"
    pritvirajmanoharan   = "keybase:prithvi_ri"
    prashantramcharan    = "keybase:prashant_ri"
    amitkumar            = "keybase:amitkumar"
    poojababurajan       = "keybase:poojababurajan"
    rinkupoptani         = "keybase:rinxp"
    manojjose            = "keybase:manojjose"
    tomrobson            = "keybase:tomrobson7"
    richardlloyd         = "keybase:richardlloyd"
    stefancocora         = "keybase:stefanco"
    sarojraut            = "keybase:sarojraut"
    chriswheelhouse      = "keybase:chriswheelhouse"
    donotdeleteme7       = "${var.dummy_pgp_key}"
    keerthikrishnamurthy = "keybase:kbkeerthik"
    dandillingham        = "keybase:dandillinghamri"
    donotdeletemeFRDS    = "${var.dummy_pgp_key}"
    bendavies            = "keybase:eggsbenjamin"
    alantyler            = "keybase:alantylerri"
    chrisjaques          = "keybase:jaquesc"
    donotdeletemecp      = "${var.dummy_pgp_key}"
    sabbirahmed          = "keybase:jaquesc"
    adrianchristian      = "keybase:jaquesc"
    bamdaddashtban       = "keybase:bamdad"
    robertjoscelyne      = "keybase:robertjoscelyne"
    sarikasharma         = "keybase:sarika_aws"
    caitlingulliford     = "keybase:cgulli"
    mariopaphitis        = "keybase:jaquesc"
    pauloschneider       = "keybase:phss"
    patrickoladimeji     = "keybase:thehogfather"
    vicencgarcia         = "keybase:vgaltes"
    javiergomez          = "keybase:javiergomezz"
    andreabianchi        = "keybase:andrea3bianchi"
    rajaharumugam        = "keybase:jaquesc"
    donotdeletemebs      = "${var.dummy_pgp_key}"
    benprudence          = "keybase:perkimon"
    aaronphilbertchedick = "keybase:perkimon"
    kawahcheung          = "keybase:perkimon"
    matthewwoodruff      = "keybase:tuos"
    vedavallikanala      = "keybase:vedakanala"
    sergetanpanza        = "keybase:stanpanza"
    marylrodrigues       = "keybase:marylrod"
    babitharakesh        = "keybase:babi"
    donotdeletemeMGT123  = "${var.dummy_pgp_key}"
    danwilliams          = "keybase:mikecharles"
    mariogiamp           = "keybase:mariogiamp"
    fergusorbach         = "keybase:gerauf"
    vincentdavies        = "keybase:bprudence_ri"
    keithdevlin          = "keybase:keithdevlin"
    mirceamoise          = "keybase:mirceamoise"
    daryakostenko        = "keybase:daryakostenko"
    deletedianroberts    = "${var.dummy_pgp_key}"
    donotdeletemeABC789  = "${var.dummy_pgp_key}"
    deletedparis         = "keybase:perkimon"
    parisgoudas          = "keybase:decimal"
    linaalagrami         = "keybase:perkimon"
    ianroberts           = "keybase:ianrobertsri"
    dougjeffery          = "keybase:djfresh66"
    chandreshpatel       = "keybase:jaquesc"
    jiesellebokodi       = "keybase:jieselle" 
  }
}
