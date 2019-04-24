// each module creates administrators, developers and operations groups per aws account.
// these groups build trust relationships with roles in those accounts so you can assume those roles.
// sounds confusing right? It kindof is if you don't understand how IAM works. So here is an example.
// Become a member of the enactor developers group, and you can assume the developers role in each account.
// The role has read write to dev & staging and read only in production by default, unless otherwise overriden.
// Still don't understand? Ignore this and carry on with the readme, or read this link
// https://start.jcolemorrison.com/aws-iam-policies-in-a-nutshell/
// When someone leaves you must remove their account from this file, there's no need to replace it with anything

module "all_river_island_aws_account_ids" {
  source = "../../../modules/aws_accounts"
}

// IAM Account. This is the one you sign into before you assume roles.
module "iam" {
  source = "../../../modules/iam_root_member_account"

  project_name = "iam"

  // DO NOT ADD YOURSELF TO THESE GROUPS UNLESS YOU KNOW WHAT YOU'RE DOING!
  // This will allow you to assume developer group access in all accounts and manage IAM users MFA devices and Passwords.
  aws_account_ids = "${module.all_river_island_aws_account_ids.account_ids}"

  developer_group_membership = [
    "stefancocora",
  ]
}

output "iam_switch_role_links" {
  value = "${module.iam.iam_switch_role_links}"
}

// STEP 3 - Add yourself to the groups in each aws_accounts where appropriate.

module "enactor" {
  source = "../../../modules/iam_root_member_account"

  project_name = "enactor"

  # each of these accounts must have the roles provisioned in them
  aws_account_ids = {
    dev        = "666469064441"
    staging    = "338727929577"
    sit        = "543766059565"
    management = "350793678069"
    prod       = "204403389885"
  }

  // STEP 3.* - Add yourself to these groups where appropriate

  administrator_group_membership = []
  developer_group_membership = [
    "charleswilkinson",
    "malonieguha",
    "atanaskanchev",
    "pritvirajmanoharan",
    "prashantramcharan",
    "amitkumar",
    "poojababurajan",
    "chriswheelhouse",
    "keerthikrishnamurthy",
    "dandillingham",
    "arjunmakineni",
    "alantyler",
    "vicencgarcia",
    "javiergomez",
    "mikecharles",
    "benprudence",
    "kawahcheung",
    "vincentdavies",
    "willperkins",
    "ruaanventer",
  ]
  operations_group_membership = [
    "chrisjaques",
    "sabbirahmed",
    "adrianchristian",
    "mariopaphitis",
    "richardlloyd",
    "dandillingham",
    "mikecharles",
    "rajaharumugam",
    "vicencgarcia",
    "javiergomez",
    "benprudence",
    "kawahcheung",
    "vincentdavies",
    "chandreshpatel",
  ]
}

output "enactor_switch_role_links" {
  value = "${module.enactor.iam_switch_role_links}"
}

module "rfid" {
  source = "../../../modules/iam_root_member_account"

  project_name = "rfid"

  aws_account_ids = {
    dev        = "217777530268"
    staging    = "575393571653"
    prod       = "215821541440"
    management = "728741135697"
  }

  // STEP 3.* - Add yourself to these groups where appropriate

  administrator_group_membership = []
  developer_group_membership = [
    "chrisharding",
    "davidtedwards",
    "martingallagher",
    "nimahlganesh",
    "willperkins",
    "mikesmart",
    "charleswilkinson",
    "mikecharles",
    "ruaanventer",
    "poojababurajan",
    "rinkupoptani",
    "manojjose",
    "richardlloyd",
    "keerthikrishnamurthy",
    "bendavies",
    "aaronphilbertchedick",
    "parisgoudas",
  ]
  operations_group_membership = []
}

output "rfid_switch_role_links" {
  value = "${module.rfid.iam_switch_role_links}"
}

module "transit" {
  source = "../../../modules/iam_root_member_account"

  project_name = "transit"

  aws_account_ids = {
    dev  = "556748783639"
    prod = "376076567968"
  }

  // STEP 3.* - Add yourself to these groups where appropriate
  developer_group_membership = [
    "chrisharding",
    "davidtedwards",
    "martingallagher",
    "nimahlganesh",
    "willperkins",
    "mikesmart",
    "charleswilkinson",
    "ruaanventer",
    "prashantramcharan",
    "poojababurajan",
    "rinkupoptani",
    "manojjose",
    "richardlloyd",
    "sarojraut",
    "keerthikrishnamurthy",
    "dandillingham",
    "bendavies",
    "bamdaddashtban",
    "pauloschneider",
    "patrickoladimeji",
    "vicencgarcia",
    "pritvirajmanoharan",
    "javiergomez",
    "andreabianchi",
    "benprudence",
    "aaronphilbertchedick",
    "kawahcheung",
    "matthewwoodruff",
    "sergetanpanza",
    "marylrodrigues",
    "babitharakesh",
    "mariogiamp",
    "fergusorbach",
    "vincentdavies",
    "keithdevlin",
    "parisgoudas",
    "ianroberts",
    "dougjeffery",
    "jiesellebokodi",  
]

  operations_group_membership = [
    "tomrobson",
    "mikecharles",
  ]

  administrator_group_membership = [
    "willperkins",
    "chrisharding",
    "nimahlganesh",
  ]
}

output "transit_switch_role_links" {
  value = "${module.transit.iam_switch_role_links}"
}

module "order" {
  source = "../../../modules/iam_root_member_account"

  project_name = "order"

  aws_account_ids = {
    management = "710660959603"
    dev        = "677677631524"
    staging    = "444440085706"
    prod       = "978203441460"
  }

  // STEP 3.* - Add yourself to these groups where appropriate
  developer_group_membership = [
    "chrisharding",
    "davidtedwards",
    "tomrobson",
    "sarojraut",
    "atanaskanchev",
    "bendavies",
    "andreabianchi",
    "sergetanpanza",
  ]

  administrator_group_membership = [
    "chrisharding",
    "bendavies",
    "andreabianchi",
    "sergetanpanza",
  ]

  operations_group_membership = [
    "benprudence",
    "vincentdavies",
    "mariopaphitis",
  ]
}

output "order_switch_role_links" {
  value = "${module.order.iam_switch_role_links}"
}

// account for the Styleman v11 implemtation
module "styleman" {
  source = "../../../modules/iam_root_member_account"

  project_name = "styleman"

  aws_account_ids = {
    prod = "154443489402"
  }

  // STEP 3.* - Add yourself to these groups where appropriate

  administrator_group_membership = []
  developer_group_membership = [
    "chrisharding",
    "charleswilkinson",
    "ruaanventer",
    "benprudence",
    "vincentdavies",
  ]
  operations_group_membership = []
}

output "styleman_switch_role_links" {
  value = "${module.styleman.iam_switch_role_links}"
}

module "payment" {
  source = "../../../modules/iam_root_member_account"

  project_name = "payment"

  # each of these accounts must have the roles provisioned in them
  aws_account_ids = {
    dev        = "422623829475"
    staging    = "604348131381"
    management = "713021333007"
    prod       = "952557720835"
  }

  // STEP 3.* - Add yourself to these groups where appropriate

  administrator_group_membership = []
  developer_group_membership = [
    "charleswilkinson",
    "arjunmakineni",
    "mikecharles",
    "malonieguha",
    "atanaskanchev",
    "pritvirajmanoharan",
    "prashantramcharan",
    "amitkumar",
    "poojababurajan",
    "chrisharding",
    "keerthikrishnamurthy",
    "martingallagher",
    "davidtedwards",
    "bendavies",
    "atanaskanchev",
    "rinkupoptani",
    "aaronphilbertchedick",
  ]
  operations_group_membership = [
    "chrisjaques",
  ]
}

output "payment_switch_role_links" {
  value = "${module.payment.iam_switch_role_links}"
}

// this is a test account for infrastructure development
module "test" {
  source = "../../../modules/iam_root_member_account"

  project_name = "test"

  aws_account_ids = {
    dev = "460402331925"
  }

  // STEP 3.* - Add yourself to these groups where appropriate

  developer_group_membership = [
    "charleswilkinson",
    "arjunmakineni",
    "malonieguha",
    "atanaskanchev",
    "mikecharles",
    "chrisharding",
    "pritvirajmanoharan",
    "prashantramcharan",
    "amitkumar",
    "poojababurajan",
    "ruaanventer",
    "tomrobson",
    "richardlloyd",
    "sarojraut",
    "keerthikrishnamurthy",
    "davidtedwards",
    "bendavies",
    "vicencgarcia",
    "robertjoscelyne",
    "bamdaddashtban",
    "sarikasharma",
    "pritvirajmanoharan",
    "caitlingulliford",
    "pauloschneider",
    "patrickoladimeji",
    "javiergomez",
    "matthewwoodruff",
    "vedavallikanala",
    "sergetanpanza",
    "marylrodrigues",
    "babitharakesh",
    "mariogiamp",
    "danwilliams",
    "fergusorbach",
    "keithdevlin",
    "mirceamoise",
    "daryakostenko",
    "parisgoudas",
    "linaalagrami",
    "andreabianchi",
    "ianroberts",
    "willperkins",
    "dougjeffery",
    "jiesellebokodi"  
]
  operations_group_membership = []
}

output "test_switch_role_links" {
  value = "${module.test.iam_switch_role_links}"
}

// this is a management account for general infra, it hosts docker registries etc
module "management" {
  source = "../../../modules/iam_root_member_account"

  project_name = "management"

  aws_account_ids = {
    dev = "002540887416"
  }

  // STEP 3.* - Add yourself to these groups where appropriate

  administrator_group_membership = [
    "stefancocora",
  ]
  developer_group_membership = [
    "chrisharding",
    "martingallagher",
    "willperkins",
    "charleswilkinson",
    "mikecharles",
    "davidtedwards",
    "richardlloyd",
    "keerthikrishnamurthy",
    "sarojraut",
    "tomrobson",
    "rinkupoptani",
    "bendavies",
    "aaronphilbertchedick",
  ]
  operations_group_membership = []
}

output "management_switch_role_links" {
  value = "${module.management.iam_switch_role_links}"
}

// this is a monitoring account for cloudtrail logs, dashboards etc
module "monitoring" {
  source = "../../../modules/iam_root_member_account"

  project_name = "monitoring"

  aws_account_ids = {
    prod = "627505981536"
  }

  // STEP 3.* - Add yourself to these groups where appropriate

  developer_group_membership = [
    "chrisharding",
    "martingallagher",
    "willperkins",
    "charleswilkinson",
    "mikecharles",
    "ruaanventer",
    "davidtedwards",
    "richardlloyd",
    "keerthikrishnamurthy",
    "bendavies",
    "rinkupoptani",
    "aaronphilbertchedick",
  ]
  operations_group_membership = []
}

output "monitoring_switch_role_links" {
  value = "${module.monitoring.iam_switch_role_links}"
}

// this is the root account for aws organisations and billing
module "root_account" {
  source = "../../../modules/iam_root_member_account"

  project_name = "root"

  aws_account_ids = {
    prod = "548502469463"
  }

  // STEP 3.* - Add yourself to these groups where appropriate

  developer_group_membership = [
    "willperkins",
    "charleswilkinson",
    "mikecharles",
  ]
  operations_group_membership = []
}

output "root_switch_role_links" {
  value = "${module.root_account.iam_switch_role_links}"
}

// this is an isolated POC account to try things out. It should be wiped regularly.
module "poc_account" {
  source = "../../../modules/iam_root_member_account"

  project_name = "pocs"

  aws_account_ids = {
    dev = "168416847939"
  }

  // STEP 3.* - Add yourself to these groups where appropriate

  developer_group_membership = [
    "prashantramcharan",
    "richardlloyd",
    "keerthikrishnamurthy",
    "dougjeffery",
  ]
  operations_group_membership = []
}

output "pocs_switch_role_links" {
  value = "${module.poc_account.iam_switch_role_links}"
}

module "product" {
  source = "../../../modules/iam_root_member_account"

  project_name = "product"

  # each of these accounts must have the roles provisioned in them
  aws_account_ids = {
    dev        = "749976638670"
    staging    = "521223572942"
    management = "125479865773"
    prod       = "501628970936"
  }

  // STEP 3.* - Add yourself to these groups where appropriate

  administrator_group_membership = [
    "stefancocora",
  ]
  developer_group_membership = [
    "richardlloyd",
    "ruaanventer",
    "robertjoscelyne",
    "bamdaddashtban",
    "sarikasharma",
    "pritvirajmanoharan",
    "caitlingulliford",
    "pauloschneider",
    "patrickoladimeji",
    "matthewwoodruff",
    "vedavallikanala",
    "davidtedwards",
    "marylrodrigues",
    "babitharakesh",
    "mariogiamp",
    "fergusorbach",
    "keithdevlin",
    "mirceamoise",
    "daryakostenko",
    "linaalagrami",
    "ianroberts",
    "dougjeffery",
    "jiesellebokodi", 
 ]
  operations_group_membership = []
}

output "product_switch_role_links" {
  value = "${module.product.iam_switch_role_links}"
}

// STEP 4 - If you are reading this, we are presuming you haven't done anything crazy.
// You will need to go look at the terraform plan in CI under the non_product job and the root_iam task to see if everything looks ok. Ensure it passes the linters.
// Once satisfied, add a comment to the created pull request saying "Please examine the terraform state to see if this looks OK"

// output the encrypted passwords so they can be pgp decrypted with keybase by users.
output "aws_iam_users_encrypted_passwords" {
  value = "${zipmap(keys(module.iam_root_account.aws_iam_users_encrypted_passwords), formatlist("\n\n-----BEGIN PGP MESSAGE-----\n\n%s\n\n-----END PGP MESSAGE-----\n", values(module.iam_root_account.aws_iam_users_encrypted_passwords)))}"
}
