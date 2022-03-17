using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ObjectPool : MonoBehaviour
{
    public static ObjectPool Instance;

    [SerializeField]
    private GameObject BookPrefeb;
    private Queue<Book> BookQueue = new Queue<Book>();

    [SerializeField]
    private GameObject ApplePrefeb;
    private Queue<Apple> AppleQueue = new Queue<Apple>();

    private void Awake()
    {
        Instance = this;

        InitializeBook(40);
        InitializeApple(5);
    }

    //시작시 풀링에 오브젝트 미리 생성
    private void InitializeBook(int count)
    {
        for(int i=0;i<count; i++)
        {
            BookQueue.Enqueue(CreateNewBook());
        }
    }

    private void InitializeApple(int count)
    {
        for (int i = 0; i < count; i++)
        {
            AppleQueue.Enqueue(CreateNewApple());
        }
    }


    //새로운 오브젝트 생성
    private Book CreateNewBook()
    {
        var newBook = Instantiate(BookPrefeb, transform).GetComponent<Book>();
        newBook.gameObject.SetActive(false);
        return newBook;
    }

    private Apple CreateNewApple()
    {
        var newApple = Instantiate(ApplePrefeb, transform).GetComponent<Apple>();
        newApple.gameObject.SetActive(false);
        return newApple;
    }



    //오브젝트 빌려주기
    public static Book GetBook()
    {
        if(Instance.BookQueue.Count>0)
        {
            var book = Instance.BookQueue.Dequeue();
            book.transform.SetParent(null);
            book.gameObject.SetActive(true);
            return book;
        }
        else
        {
            var newbook = Instance.CreateNewBook();
            newbook.transform.SetParent(null);
            newbook.gameObject.SetActive(true);
            return newbook;
        }
    }
    public static Apple GetApple()
    {
        if (Instance.AppleQueue.Count > 0)
        {
            var apple = Instance.AppleQueue.Dequeue();
            apple.transform.SetParent(null);
            apple.gameObject.SetActive(true);
            return apple;
        }
        else
        {
            var newapple = Instance.CreateNewApple();
            newapple.transform.SetParent(null);
            newapple.gameObject.SetActive(true);
            return newapple;
        }
    }

    //오브젝트 돌려받기
    public static void ReturnBook(Book book)
    {
        book.gameObject.SetActive(false);
        book.transform.SetParent(Instance.transform);
        Instance.BookQueue.Enqueue(book);
    }
    public static void ReturnApple(Apple apple)
    {
        apple.gameObject.SetActive(false);
        apple.transform.SetParent(Instance.transform);
        Instance.AppleQueue.Enqueue(apple);
    }

    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
