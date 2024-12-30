import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:naive_cross_word/naive_cross_word.dart';
import 'package:teka_teki_tiku/counter/counter.dart';

class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterCubit(),
      child: const CounterView(),
    );
  }
}

class CounterView extends StatelessWidget {
  const CounterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teka Teki Tiki')),
      body: CrosswordWidget(
        crossWordModel: dummyCrossWordModel,
      ),
      // body: InteractiveViewer(
      //   panEnabled: false, // Set it to false to prevent panning.

      //   minScale: 0.5,
      //   maxScale: 4,
      //   child: CrosswordWidget(
      //     words: const [
      //       {"description": "Anak yang terlahir di tengah perjamuan atau perhelatan", "answer": "wahana", "number": 1},
      //       {"number": 2, "description": "Bengkel tempat kerja para seniman", "answer": "Atelir"},
      //       {"number": 3, "description": "Tukang kayu", "answer": "Acawi"},
      //       {"number": 4, "description": "Aneh; tidak biasa", "answer": "Asing"},
      //       {"number": 5, "description": "Strok karena serangan jantung mendadak", "answer": "Belawa"},
      //       {"number": 6, "description": "Rujak dari iris-irisan mentimun yang dibubuhi cabai atau garam", "answer": "Kerabu"},
      //       {"description": "Tukang gunting pakaian yang akan dijahit", "answer": "kupir", "number": 6},
      //       {"number": 7, "description": "Bangunan darurat; bangunan sementara", "answer": "Petaruan"},
      //       {"number": 8, "description": "Mengangkat sesuatu beramai-ramai dan mendorongnya lambat-lambat", "answer": "Rande"},
      //       {"number": 9, "description": "Tempat tukang besi bekerja", "answer": "Apar"},
      //       {"description": "Pekerja; buruh", "answer": "ajir", "number": 9},
      //       {"number": 10, "description": "Ukuran panjang sama dengan 2,54 cm", "answer": "Inci"},
      //       {"number": 11, "description": "Ahli pahat arca, relief, dan candi", "answer": "Taksaka"},
      //       {"description": "Teras tengah batang dan akar tumbuhan berpembuluh", "answer": "stele", "number": 12},
      //       {"description": "Kantor berita Prancis", "answer": "AFP", "number": 13},
      //       {"number": 14, "description": "Kombinasi dari beberapa komponen", "answer": "Kombo"},
      //       {"description": "Penyimpangan dari yang normal", "answer": "aberasi", "number": 15},
      //       {"description": "Menanam tebu dengan menggunakan bibit dari sisa panen yang dipelihara hingga tumbuh tunas baru", "answer": "ratun", "number": 16},
      //       {"description": "Ikan kecil yang diawetkan dalam botol dengan menggunakan garam dan pengawet, lalu diberi pewarna", "answer": "cao", "number": 17},
      //       {"description": "Cuping pada sayap belakang serangga", "answer": "neala", "number": 18},
      //       {"description": "Tukang jahit", "answer": "darji", "number": 19},
      //       {"number": 20, "description": "Bagian yang dangkal pada sungai", "answer": "Aran"},
      //       {"number": 21, "description": "Huruf ke-5 abjad Arab", "answer": "Jim"},
      //       {"description": "Ikuti; sertai", "answer": "iring", "number": 22},
      //       {"number": 23, "description": "Rasa takut yang berlebihan terhadap radiasi atau sinar x", "answer": "Radiofobia"},
      //       {"number": 24, "description": "Sungai di Afrika", "answer": "Nil"},
      //       {"description": "Pemangkas rambut", "answer": "barber", "number": 25},
      //       {"description": "Ibu kota Negara Ghana", "answer": "akra", "number": 26},
      //       {"description": "Bejana besar dari tanah untuk tempat air", "answer": "pasu", "number": 27},
      //       {
      //         "number": 28,
      //         "description": "Grafik bunyi yang menginformasikan tentang perubahan dalam rentang waktu, frekuensi, dan intensitas gelombang bunyi menurut sumbu waktu",
      //         "answer": "Spektogram"
      //       },
      //       {"description": "Selada yang disajikan dengan saus, dapat berupa saus berbasis tahu, miso, atau wijen", "answer": "aemono", "number": 29},
      //       {"number": 30, "description": "Elak dari serangan", "answer": "Egos"},
      //       {"number": 31, "description": "Negara beribu kota Managua", "answer": "Nikaragua"},
      //       {"description": "Rakyat biasa", "answer": "dula", "number": 32},
      //       {"number": 33, "description": "Otot abdominal", "answer": "Abs"},
      //       {"number": 34, "description": "Sekadar mengikuti tata cara; basa-basi", "answer": "Formalitas"},
      //       {"description": "Jari tangan dan kaki", "answer": "falang", "number": 34},
      //       {"number": 35, "description": "Kantor berita Belanda", "answer": "ANP"},
      //       {"description": "Kata sapaan kepada pembesar orang Tionghoa", "answer": "aboi", "number": 36},
      //       {"number": 37, "description": "Hari ini, 1 Desember 2024 berlangsung lomba lari di Kabupaten Magelang yang dikelola oleh KOMPAS", "answer": "Borobudur Marathon"},
      //       {"description": "Tumbuhan yang mengambang di air, dibudidayakan di rawa-rawa untuk dibuat sayur", "answer": "kemon", "number": 38},
      //       {"description": "Faktor pembatas yang merupakan sawar pemisah populasi", "answer": "obeks", "number": 39},
      //       {"number": 40, "description": "Mantra yang menjadikan seseorang memiliki kekuatan yang luar biasa", "answer": "Bala seribu"},
      //       // {"description": "Pidato", "answer": "orasi", "number": 41},
      //       // {"number": 42, "description": "Sehat", "answer": "Afiat"},
      //       // {"number": 43, "description": "Gusi", "answer": "Isit"},
      //       // {"description": "Alat untuk menggulung kain yang sudah ditenun", "answer": "pesa", "number": 44},
      //       // {"number": 45, "description": "Suku bangsa yang mendiami Pegunungan Jayawijaya bagian barat, Papua", "answer": "Ekagi"},
      //       // {"description": "Cetak coba", "answer": "pruf", "number": 46},
      //       // {"description": "Pemungutan suara", "answer": "seteman", "number": 47},
      //       // {"number": 48, "description": "Bekas hitam pada bagian tubuh sejak lahir dan mempunyai pengaruh bagi jalan hidup seseorang", "answer": "Naga"},
      //       // {"description": "Air bekas cucian beras", "answer": "leri", "number": 49},
      //       // {"description": "Pendapat; pikiran", "answer": "opini", "number": 50},
      //       // {"description": "Keladi yang tumbuh di sela-sela padi", "answer": "alata", "number": 51},
      //       // {"description": "Embusan udara yang keluar dari mulut", "answer": "abab", "number": 52},
      //       // {"description": "Bahasa yang dituturkan di Filipina", "answer": "tagalog", "number": 53},
      //       // {"description": "Catur Jepang", "answer": "sogi", "number": 54},
      //       // {"description": "Asosiasi Transportasi Udara Internasional (singkatan/Inggris)", "answer": "IATA", "number": 55},
      //       // {"number": 56, "description": "Suku bangsa yang mendiami Provinsi Aceh", "answer": "Alas"},
      //       // {"number": 57, "description": "Rasi bintang yang terletak di belahan langit selatan", "answer": "Ara"},
      //       // {"description": "Kartun khas Jepang", "answer": "anime", "number": 58},
      //       // {"number": 59, "description": "Penyumbat lubang keluar mesiu pada meriam", "answer": "Nal"},
      //       // {"description": "Sangat sesuai dengan yang dikehendaki", "answer": "ideal", "number": 60},
      //       // {"number": 61, "description": "Hari ini, 1 Desember 2024 berlangsung lomba lari di Kabupaten Magelang yang dikelola oleh KOMPAS", "answer": "Borobudur Marathon"},
      //       // {"description": "Penganan khas Turki, seperti pangsit, diisi daging sapi", "answer": "manti", "number": 61},
      //       // {"description": "Buih", "answer": "ruap", "number": 62},
      //       // {"number": 63, "description": "Tulisan atau gambar yang ditampilkan secara daring di media sosial atau blog", "answer": "Posting"},
      //       // {"description": "Cincin kawin; tanda jadi", "answer": "acaram", "number": 64},
      //       // {"number": 65, "description": "Perasaan hati", "answer": "Cita"},
      //       // {"description": "Satuan mata uang Georgia", "answer": "lari", "number": 66},
      //       // {"number": 67, "description": "", "answer": "Awa"},
      //       // {"number": 68, "description": "Momen gaya", "answer": "Torka"},
      //       // {"description": "Penarikan", "answer": "traksi", "number": 68},
      //       // {"number": 69, "description": "Kue kering khas Sangir dari adonan sagu, kacang hijau, kacang tanah, kemudian dipanggang", "answer": "Koa"},
      //       // {"number": 70, "description": "Penganan dari tepung beras, dicampur gula putih yang dipanaskan, kemudian digoreng", "answer": "Andara"},
      //       // {"description": "Penyakit sesak napas", "answer": "asma", "number": 70},
      //       // {"number": 71, "description": "Nama belakang Juara Dunia MotoGP 2024", "answer": "(Jorge) Martin"},
      //       // {"description": "Tenaga pendorong dalam hati manusia untuk mendapatkan manfaat dan menolak kemudaratan", "answer": "bais", "number": 72},
      //       // {"number": 73, "description": "Makanan atau gizi", "answer": "Alimen"},
      //       // {"description": "Stempel; cetakan", "answer": "teraan", "number": 74},
      //       // {"number": 75, "description": "Kata sapaan kepada anak perempuan", "answer": "Embih"},
      //       // {"number": 76, "description": "Gangguan bicara, kesalahan dalam ucapan dengan mengulang-ulang bunyi, suku kata atau kata", "answer": "Gagap"},
      //       // {"description": "Ikan kepala timah", "answer": "gatul", "number": 76},
      //       // {"number": 77, "description": "Tubuh vegetatif tumbuhan rendah yang tidak terbagi atas akar, batang, dan daun", "answer": "Talus"},
      //       // {"number": 78, "description": "Pedang", "answer": "Saif"},
      //       // {"description": "Batuan khas Indonesia yang ditemukan di pulau Belitung, berwarna hitam dan memiliki urat-urat yang khas", "answer": "satam", "number": 78},
      //       // {"number": 79, "description": "Tiang bendera", "answer": "Tual"},
      //       // {"description": "Sungguh-sungguh dalam menekuni sesuatu", "answer": "daria", "number": 80},
      //       // {"description": "Kantor berita Kenya", "answer": "KNA", "number": 81},
      //       // {"description": "Kata penghubung untuk menyatakan isi atau uraian bagian kalimat yang di depan", "answer": "bahwa", "number": 82},
      //       // {"description": "Selubung; selimut", "answer": "gelimun", "number": 83},
      //       // {"description": "Berlaku; sah", "answer": "aci", "number": 84},
      //       // {"description": "Nama depan penyanyi lagu Kali Kedua", "answer": "raisa", "number": 85},
      //       // {"description": "Perbuatan; tingkah laku", "answer": "afal", "number": 86},
      //       // {"description": "Buah tumbuhan teratai", "answer": "hunta", "number": 87},
      //       // {"description": "Gelisah; busung", "answer": "pusang", "number": 88}
      //     ],
      //     onRevealCurrentCellLetter: (_) {},
      //   ),
      // ),
    );
  }
}

class CounterText extends StatelessWidget {
  const CounterText({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = context.select((CounterCubit cubit) => cubit.state);
    return Text('$count', style: theme.textTheme.displayLarge);
  }
}
